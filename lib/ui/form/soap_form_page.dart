import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';
import 'package:solution_challenge_tcu_2025/gemini/gemini_service.dart';

class SoapFormPage extends StatefulWidget {
  final Patient patient;
  final Soap? soap;

  const SoapFormPage({super.key, required this.patient, this.soap});

  @override
  State<SoapFormPage> createState() => _SoapFormPageState();
}

class _SoapFormPageState extends State<SoapFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _displayDateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  late DateTime _issueDateTime;
  late TextEditingController _subjectController;
  late TextEditingController _objectController;
  late TextEditingController _assessmentController;
  late TextEditingController _planController;

  // A getter to determine if we're in edit mode
  bool get isEditMode => widget.soap != null;

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      // Edit mode - initialize with existing SOAP data
      final s = widget.soap!;
      _issueDateTime = s.issueDateTime;
      _subjectController = TextEditingController(text: s.subject);
      _objectController = TextEditingController(text: s.object);
      _assessmentController = TextEditingController(text: s.assessment);
      _planController = TextEditingController(text: s.plan);
    } else {
      // Add mode - initialize with empty values
      _issueDateTime = DateTime.now();
      _subjectController = TextEditingController();
      _objectController = TextEditingController();
      _assessmentController = TextEditingController();
      _planController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _objectController.dispose();
    _assessmentController.dispose();
    _planController.dispose();
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
        // If time selection is canceled, the date will not be changed
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
    ); // cancel if null
    if (memo == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final Soap generatedSoap = await geminiService.generateSoap(
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

      // Show dialog to confirm generated SOAP
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Generated SOAP'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject: ${generatedSoap.subject}'),
                  Text('Object: ${generatedSoap.object}'),
                  Text('Assessment: ${generatedSoap.assessment}'),
                  Text('Plan: ${generatedSoap.plan}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
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
        // Apply generated SOAP to input fields
        setState(() {
          _subjectController.text = generatedSoap.subject;
          _objectController.text = generatedSoap.object;
          _assessmentController.text = generatedSoap.assessment;
          _planController.text = generatedSoap.plan;
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (isEditMode) {
        // Edit mode - update existing SOAP
        final soap = widget.soap!;
        soap.issueDateTime = _issueDateTime;
        soap.subject = _subjectController.text;
        soap.object = _objectController.text;
        soap.assessment = _assessmentController.text;
        soap.plan = _planController.text;
      } else {
        // Add mode - create new SOAP and add to patient history
        final newSoap = Soap(
          issueDateTime: _issueDateTime,
          subject: _subjectController.text,
          object: _objectController.text,
          assessment: _assessmentController.text,
          plan: _planController.text,
        );
        widget.patient.addHistoryOfSoap(newSoap);
      }

      await PatientRepository().updatePatient(widget.patient);
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    int minLines = 1,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        minLines: minLines,
        maxLines: maxLines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'SOAPの編集' : 'SOAPの作成')),
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
                  _buildTextFormField(
                    _subjectController,
                    'S (主観的情報)',
                    minLines: 1,
                    maxLines: null,
                  ),
                  _buildTextFormField(
                    _objectController,
                    'O (客観的情報)',
                    minLines: 1,
                    maxLines: null,
                  ),
                  _buildTextFormField(
                    _assessmentController,
                    'A (アセスメント)',
                    minLines: 1,
                    maxLines: null,
                  ),
                  _buildTextFormField(
                    _planController,
                    'P (プラン)',
                    minLines: 1,
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
