import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/nursing_plan.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
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
  final _displayDateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  late DateTime _issueDateTime;
  late TextEditingController _nandaIController;
  late TextEditingController _goalController;
  late TextEditingController _opController;
  late TextEditingController _tpController;
  late TextEditingController _epController;

  @override
  void initState() {
    super.initState();
    final plan = widget.patient.nursingPlan;
    _issueDateTime = plan.issueDateTime;
    _nandaIController = TextEditingController(text: plan.nanda_i);
    _goalController = TextEditingController(text: plan.goal);
    _opController = TextEditingController(text: plan.op);
    _tpController = TextEditingController(text: plan.tp);
    _epController = TextEditingController(text: plan.ep);
  }

  @override
  void dispose() {
    _nandaIController.dispose();
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
        nanda_i: _nandaIController.text,
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
    final String? memo = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter notes for Gemini'),
          content: TextField(
            controller: memoController,
            decoration: const InputDecoration(hintText: 'Enter notes'),
            maxLines: 3,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(memoController.text),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    // cancel if null
    if (memo == null) return;

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
            title: const Text('Generated nursing plan'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NANDA-I: ${generatedPlan.nanda_i}'),
                  Text('Goal: ${generatedPlan.goal}'),
                  Text('O-P (Observation): ${generatedPlan.op}'),
                  Text('T-P (Therapeutic): ${generatedPlan.tp}'),
                  Text('E-P (Educational): ${generatedPlan.ep}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Reject'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Accept'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Apply generated plan to input fields
        setState(() {
          _nandaIController.text = generatedPlan.nanda_i;
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
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    int? maxLines,
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
                      child: ElevatedButton.icon(
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
                  _buildTextFormField(_nandaIController, 'NANDA-I'),
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
          if (_isLoading)
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
