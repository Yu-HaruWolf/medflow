import functions_framework
from flask import jsonify, make_response  # ✅ make_response を追加

from google import genai
from google.genai.types import Tool, GenerateContentConfig, GoogleSearch
from markupsafe import escape

client = genai.Client(api_key="api_key")  # APIキーを指定
model_id = "gemini-2.0-flash"
google_search_tool = Tool(google_search=GoogleSearch())

@functions_framework.http
def hello_http(request):
    # CORS対応ヘッダー
    cors_headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
    }

    # Preflightリクエスト対応
    if request.method == 'OPTIONS':
        return ('', 204, cors_headers)

    try:
        prompt = request.args.get("prompt", "Please tell me a NANDA-I")

        response = client.models.generate_content(
            model=model_id,
            contents=prompt,
            config=GenerateContentConfig(
                tools=[google_search_tool],
                response_modalities=["TEXT"],
            )
        )

        parts = response.candidates[0].content.parts
        texts = [part.text for part in parts if hasattr(part, "text")]
        reply = "\n".join(texts)

        try:
            grounding = response.candidates[0].grounding_metadata.search_entry_point.rendered_content
        except:
            grounding = "N/A"

        # レスポンスに CORS ヘッダーを追加
        resp = make_response(jsonify({
            "response": reply,
            "source": grounding
        }))
        resp.headers.update(cors_headers)
        return resp

    except Exception as e:
        # エラー時も CORS ヘッダーを返す
        resp = make_response(jsonify({"error": str(e)}), 500)
        resp.headers.update(cors_headers)
        return resp
