import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';
import 'package:solution_challenge_tcu_2025/data/soap.dart';

class EditSoapPage extends StatefulWidget {
  final Patient patient;
  final Soap soap;
  const EditSoapPage({super.key, required this.patient, required this.soap});

  @override
  State<EditSoapPage> createState() => _EditSoapPageState();
}

class _EditSoapPageState extends State<EditSoapPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _displayDateTimeFormat = DateFormat('yyyy/MM/dd HH:mm:ss');

  late DateTime _issueDateTime;
  late TextEditingController _subjectController;
  late TextEditingController _objectController;
  late TextEditingController _assessmentController;
  late TextEditingController _planController;

  @override
  void initState() {
    super.initState();
    final s = widget.soap;
    _issueDateTime = s.issueDateTime;
    _subjectController = TextEditingController(text: s.subject);
    _objectController = TextEditingController(text: s.object);
    _assessmentController = TextEditingController(text: s.assessment);
    _planController = TextEditingController(text: s.plan);
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      widget.soap.issueDateTime = _issueDateTime;
      widget.soap.subject = _subjectController.text;
      widget.soap.object = _objectController.text;
      widget.soap.assessment = _assessmentController.text;
      widget.soap.plan = _planController.text;

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
      appBar: AppBar(title: const Text('SOAPの編集')),
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
                        onPressed: () {
                          // TODO: Implement Gemini integration
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gemini で作成機能は準備中です')),
                          );
                        },
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
