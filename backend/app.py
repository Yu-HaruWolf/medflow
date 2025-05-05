from flask import Flask, request, jsonify
from google import genai
from google.genai.types import Tool, GenerateContentConfig, GoogleSearch
from flask_cors import CORS  # ← 追加
# Flask サーバー作成
app = Flask(__name__)
CORS(app) 
# Google Gemini Client の初期化
client = genai.Client(api_key="AIzaSyC3Lr1Y7CXzi4z0t6hroMvenNetcmOyYG0")
model_id = "gemini-2.0-flash"
google_search_tool = Tool(google_search=GoogleSearch())

@app.route('/ask', methods=['GET'])
def ask():
    try:
        prompt = request.args.get("prompt", "今日の東京の気温と天気を教えてください。")
                # system prompt を含めた内容に変更
        # contents = [
        #     {"role": "system", "parts": [{"text": "あなたは親切で簡潔なアシスタントです。"}]},
        #     {"role": "user", "parts": [{"text": prompt}]}
        # ]
        response = client.models.generate_content(
            model=model_id,
            contents=prompt,
            config=GenerateContentConfig(
                tools=[google_search_tool],
                response_modalities=["TEXT"],
            )
        )

        reply = "\n".join([part.text for part in response.candidates[0].content.parts])
        grounding = response.candidates[0].grounding_metadata.search_entry_point.rendered_content

        return jsonify({
            "response": reply,
            "source": grounding
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port=5000)
