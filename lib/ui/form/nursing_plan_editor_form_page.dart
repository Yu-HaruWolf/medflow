import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/speech_to_text_service.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

class NursingPlanEditorFormPage extends StatefulWidget {
  final Patient patient;
  const NursingPlanEditorFormPage({super.key, required this.patient});

  @override
  State<NursingPlanEditorFormPage> createState() =>
      _NursingPlanEditorFormPageState();
}

class _NursingPlanEditorFormPageState extends State<NursingPlanEditorFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isWaitingForResult = false;
  final _displayDateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  late DateTime _issueDateTime;
  late TextEditingController _nandaiController;
  late TextEditingController _goalController;
  late TextEditingController _opController;
  late TextEditingController _tpController;
  late TextEditingController _epController;
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  bool _isRecording = false;
  double _recordingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    final plan = widget.patient.nursingPlan;
    _issueDateTime = plan.issueDateTime;
    _nandaiController = TextEditingController(text: plan.nanda_i);
    _goalController = TextEditingController(text: plan.goal);
    _opController = TextEditingController(text: plan.op);
    _tpController = TextEditingController(text: plan.tp);
    _epController = TextEditingController(text: plan.ep);
  }

  @override
  void dispose() {
    _nandaiController.dispose();
    _goalController.dispose();
    _opController.dispose();
    _tpController.dispose();
    _epController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _issueDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_issueDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _issueDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else {
        // 時間選択をキャンセルした場合は日付も変更しない
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      widget.patient.nursingPlan = NursingPlan(
        issueDateTime: _issueDateTime,
        nanda_i: _nandaiController.text,
        goal: _goalController.text,
        op: _opController.text,
        tp: _tpController.text,
        ep: _epController.text,
      );
      await PatientRepository().updatePatient(widget.patient);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _handleGeminiCreation() async {
    final TextEditingController memoController = TextEditingController();
    final geminiService = GeminiService();
    geminiService.geminiInit();

    // Show dialog to input memo
    final String memo =
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('メモを入力してください'),
              content: TextField(
                controller: memoController,
                decoration: const InputDecoration(hintText: 'メモを入力'),
                maxLines: 3,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed:
                      () =>
                          Navigator.of(context).pop(''), // Return empty string
                  child: const Text('スキップ'),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.of(context).pop(memoController.text),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        ) ??
        ''; // Default to empty string if dialog is dismissed

    setState(() {
      _isLoading = true;
    });

    try {
      final NursingPlan generatedPlan = await geminiService.generateNursingPlan(
        widget.patient,
        widget.patient.nursingPlan,
        widget.patient.historyOfSoap.isNotEmpty
            ? widget.patient.historyOfSoap.last
            : Soap(),
        memo,
      );

      setState(() {
        _isLoading = false;
      });

      // Show dialog to confirm generated plan
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('生成された看護計画'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NANDA-I: ${generatedPlan.nanda_i}'),
                  Text('目標: ${generatedPlan.goal}'),
                  Text('O-P (観察項目): ${generatedPlan.op}'),
                  Text('T-P (援助): ${generatedPlan.tp}'),
                  Text('E-P (指導): ${generatedPlan.ep}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Apply generated plan to input fields
        setState(() {
          _nandaiController.text = generatedPlan.nanda_i;
          _goalController.text = generatedPlan.goal;
          _opController.text = generatedPlan.op;
          _tpController.text = generatedPlan.tp;
          _epController.text = generatedPlan.ep;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
    }
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    int? maxLines = null,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        maxLines: maxLines,
      ),
    );
  }

  void _startRecording() async {
    final isStarted = await _speechToTextService.startRecording();
    if (isStarted) {
      setState(() {
        _isRecording = true;
        _recordingProgress = 0.0;
      });

      // Update progress every second
      for (int i = 0; i < 59; i++) {
        await Future.delayed(const Duration(seconds: 1));
        if (!_isRecording) break;
        setState(() {
          _recordingProgress = (i + 1) / 59.0;
        });
      }

      if (_isRecording) {
        await _stopRecording();
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('マイクの権限が拒否されました')));
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
      _recordingProgress = 0.0;
      _isWaitingForResult = true;
    });

    final transcriptionResult = await _speechToTextService.stopRecording();

    setState(() {
      _isWaitingForResult = false;
    });

    if (transcriptionResult.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('文字起こし結果'),
              content: Text(transcriptionResult),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('文字起こしに失敗しました')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('看護計画の編集')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(
                              Icons.auto_awesome,
                            ), // Gemini-like icon
                            label: const Text('Gemini で作成'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.deepPurpleAccent, // Gemini-like colors
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: _handleGeminiCreation,
                          ),
                          const SizedBox(width: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_isRecording)
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    value: _recordingProgress,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                              IconButton(
                                icon: Icon(
                                  _isRecording ? Icons.stop : Icons.mic,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onPressed: () async {
                                  if (_isRecording) {
                                    await _stopRecording();
                                  } else {
                                    _startRecording();
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '作成日: ${_displayDateTimeFormat.format(_issueDateTime)}',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _pickDate(context),
                          child: const Text('日時選択'),
                        ),
                      ],
                    ),
                  ),
                  _buildTextFormField(_nandaiController, 'NANDA-I'),
                  _buildTextFormField(_goalController, '目標', maxLines: null),
                  _buildTextFormField(
                    _opController,
                    'O-P (観察項目)',
                    maxLines: null,
                  ),
                  _buildTextFormField(
                    _tpController,
                    'T-P (援助)',
                    maxLines: null,
                  ),
                  _buildTextFormField(
                    _epController,
                    'E-P (指導)',
                    maxLines: null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('保存'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          textStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                        onPressed: _submitForm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading || _isWaitingForResult)
            Positioned.fill(
              child: Stack(
                children: [
                  ModalBarrier(
                    color: Colors.black.withOpacity(0.4),
                    dismissible: false,
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
