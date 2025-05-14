import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class PatientFormPage extends StatefulWidget {
  final Patient? patient; // Add mode if null, otherwise edit mode

  const PatientFormPage({super.key, this.patient});

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Determine mode getter
  bool get isEditMode => widget.patient != null;

  // Patient Controllers
  late TextEditingController _idController;

  // PersonalInfo Controllers
  late TextEditingController _furiganaController;
  late TextEditingController _nameController;
  DateTime? _birthday;
  late TextEditingController _addressController;
  late TextEditingController _telController;

  // RelatedContacts
  List<RelatedContact> _relatedContacts = [];
  List<Map<String, TextEditingController>> _relatedContactControllers = [];

  // HealthPromotion Controllers
  late TextEditingController _preHospitalCourseController;
  late TextEditingController _chiefComplaintController;
  late TextEditingController _purposeController;
  late TextEditingController _doctorOpinionController;
  late TextEditingController _principalOpinionController;
  late TextEditingController _familyOpinionController;
  late TextEditingController _pastMedicalHistoryController;
  bool? _isMedicinesExist;
  late TextEditingController _medicinesController;
  bool? _isHealthManageMethodExist;
  late TextEditingController _healthManageMethodController;
  bool? _isSubstanceExist;
  late TextEditingController _alcoholPerDayController;
  late TextEditingController _cigarettsPerDayController;
  late TextEditingController _otherSubstanceController;
  late TextEditingController _otherSubstanceRelatedInfoController;

  // SelfPerception Controllers
  late TextEditingController _selfAwarenessController;
  late TextEditingController _worriesController;
  late TextEditingController _howCanHelpController;
  late TextEditingController _painsController;
  late TextEditingController _selfPerceptionOthersController;

  late TextEditingController _oneLineInfoController;

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      // 編集モードの初期化処理
      final p = widget.patient!;
      _idController = TextEditingController(text: p.id);
      _furiganaController = TextEditingController(
        text: p.personalInfo.furigana,
      );
      _nameController = TextEditingController(text: p.personalInfo.name);
      _birthday = p.personalInfo.birthday;
      _addressController = TextEditingController(text: p.personalInfo.address);
      _telController = TextEditingController(text: p.personalInfo.tel);

      _relatedContacts = List<RelatedContact>.from(p.relatedContacts);
      _relatedContactControllers =
          _relatedContacts
              .map(
                (rc) => {
                  'name': TextEditingController(text: rc.name),
                  'relationship': TextEditingController(text: rc.relationship),
                  'tel': TextEditingController(text: rc.tel),
                },
              )
              .toList();

      _preHospitalCourseController = TextEditingController(
        text: p.healthPromotion.preHospitalCourse,
      );
      _chiefComplaintController = TextEditingController(
        text: p.healthPromotion.chiefComplaint,
      );
      _purposeController = TextEditingController(
        text: p.healthPromotion.purpose,
      );
      _doctorOpinionController = TextEditingController(
        text: p.healthPromotion.opinions['doctor'] ?? '',
      );
      _principalOpinionController = TextEditingController(
        text: p.healthPromotion.opinions['principal'] ?? '',
      );
      _familyOpinionController = TextEditingController(
        text: p.healthPromotion.opinions['family'] ?? '',
      );
      _pastMedicalHistoryController = TextEditingController(
        text: p.healthPromotion.pastMedicalHistory,
      );
      _isMedicinesExist = p.healthPromotion.isMedicinesExist;
      _medicinesController = TextEditingController(
        text: p.healthPromotion.medicines,
      );
      _isHealthManageMethodExist = p.healthPromotion.isHealthManageMethodExist;
      _healthManageMethodController = TextEditingController(
        text: p.healthPromotion.healthManageMethod,
      );
      _isSubstanceExist = p.healthPromotion.isSubstanceExist;
      _alcoholPerDayController = TextEditingController(
        text: p.healthPromotion.alcoholPerDay?.toString() ?? '',
      );
      _cigarettsPerDayController = TextEditingController(
        text: p.healthPromotion.cigarettsPerDay?.toString() ?? '',
      );
      _otherSubstanceController = TextEditingController(
        text: p.healthPromotion.otherSubstance,
      );
      _otherSubstanceRelatedInfoController = TextEditingController(
        text: p.healthPromotion.otherSubstanceRelatedInfo,
      );

      _selfAwarenessController = TextEditingController(
        text: p.selfPerception.selfAwareness,
      );
      _worriesController = TextEditingController(
        text: p.selfPerception.worries,
      );
      _howCanHelpController = TextEditingController(
        text: p.selfPerception.howCanHelp,
      );
      _painsController = TextEditingController(text: p.selfPerception.pains);
      _selfPerceptionOthersController = TextEditingController(
        text: p.selfPerception.others,
      );

      _oneLineInfoController = TextEditingController(text: p.oneLineInfo);
    } else {
      // 追加モードの初期化処理
      _idController = TextEditingController(text: "");
      _furiganaController = TextEditingController();
      _nameController = TextEditingController();
      _addressController = TextEditingController();
      _telController = TextEditingController();

      _preHospitalCourseController = TextEditingController();
      _chiefComplaintController = TextEditingController();
      _purposeController = TextEditingController();
      _doctorOpinionController = TextEditingController();
      _principalOpinionController = TextEditingController();
      _familyOpinionController = TextEditingController();
      _pastMedicalHistoryController = TextEditingController();
      _medicinesController = TextEditingController();
      _healthManageMethodController = TextEditingController();
      _alcoholPerDayController = TextEditingController();
      _cigarettsPerDayController = TextEditingController();
      _otherSubstanceController = TextEditingController();
      _otherSubstanceRelatedInfoController = TextEditingController();

      _selfAwarenessController = TextEditingController();
      _worriesController = TextEditingController();
      _howCanHelpController = TextEditingController();
      _painsController = TextEditingController();
      _selfPerceptionOthersController = TextEditingController();

      _oneLineInfoController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _furiganaController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _telController.dispose();
    _preHospitalCourseController.dispose();
    _chiefComplaintController.dispose();
    _purposeController.dispose();
    _doctorOpinionController.dispose();
    _principalOpinionController.dispose();
    _familyOpinionController.dispose();
    _pastMedicalHistoryController.dispose();
    _medicinesController.dispose();
    _healthManageMethodController.dispose();
    _alcoholPerDayController.dispose();
    _cigarettsPerDayController.dispose();
    _otherSubstanceController.dispose();
    _otherSubstanceRelatedInfoController.dispose();
    _oneLineInfoController.dispose();

    for (var controllers in _relatedContactControllers) {
      controllers.forEach((key, controller) => controller.dispose());
    }
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(1980, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthday) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  void _addRelatedContact() {
    setState(() {
      _relatedContacts.add(RelatedContact());
      _relatedContactControllers.add({
        'name': TextEditingController(),
        'relationship': TextEditingController(),
        'tel': TextEditingController(),
      });
    });
  }

  void _removeRelatedContact(int index) {
    setState(() {
      _relatedContactControllers[index].forEach(
        (key, controller) => controller.dispose(),
      );
      _relatedContactControllers.removeAt(index);
      _relatedContacts.removeAt(index);
    });
  }

  // Helper function: Returns null if string is empty or unparsable, otherwise returns parsed integer
  int? _emptyOrInvalidAsNullInt(String text) {
    if (text.trim().isEmpty) return null;
    return int.tryParse(text.trim());
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      final personalInfo = PersonalInfo(
        furigana: _furiganaController.text,
        name: _nameController.text,
        birthday: _birthday,
        address: _addressController.text,
        tel: _telController.text,
      );

      final relatedContacts =
          _relatedContactControllers
              .map(
                (map) => RelatedContact(
                  name: map['name']!.text,
                  relationship: map['relationship']!.text,
                  tel: map['tel']!.text,
                ),
              )
              .toList();

      final healthPromotion = HealthPromotion(
        preHospitalCourse: _preHospitalCourseController.text,
        chiefComplaint: _chiefComplaintController.text,
        purpose: _purposeController.text,
        opinions: {
          "doctor": _doctorOpinionController.text,
          "principal": _principalOpinionController.text,
          "family": _familyOpinionController.text,
        },
        pastMedicalHistory: _pastMedicalHistoryController.text,
        isMedicinesExist: _isMedicinesExist,
        medicines: _isMedicinesExist == true ? _medicinesController.text : '',
        isHealthManageMethodExist: _isHealthManageMethodExist,
        healthManageMethod:
            _isHealthManageMethodExist == true
                ? _healthManageMethodController.text
                : '',
        isSubstanceExist: _isSubstanceExist,
        alcoholPerDay:
            _isSubstanceExist == true
                ? _emptyOrInvalidAsNullInt(_alcoholPerDayController.text)
                : null,
        cigarettsPerDay:
            _isSubstanceExist == true
                ? _emptyOrInvalidAsNullInt(_cigarettsPerDayController.text)
                : null,
        otherSubstance:
            _isSubstanceExist == true ? _otherSubstanceController.text : '',
        otherSubstanceRelatedInfo:
            _isSubstanceExist == true
                ? _otherSubstanceRelatedInfoController.text
                : '',
      );

      final selfPerception = SelfPerception(
        selfAwareness: _selfAwarenessController.text,
        worries: _worriesController.text,
        howCanHelp: _howCanHelpController.text,
        pains: _painsController.text,
        others: _selfPerceptionOthersController.text,
      );

      final patientRepository = PatientRepository();
      try {
        if (isEditMode) {
          // 編集モード: 既存の Patient を更新
          final updatedPatient = Patient(
            id: widget.patient!.id, // 既存の ID を維持
            personalInfo: personalInfo,
            oneLineInfo: _oneLineInfoController.text,
            relatedContacts: relatedContacts,
            healthPromotion: healthPromotion,
            selfPerception: selfPerception,
            // 他の必要なフィールドは元の Patient からコピー
            nursingPlan: widget.patient!.nursingPlan,
            historyOfSoap: widget.patient!.historyOfSoap,
          );
          await patientRepository.updatePatient(updatedPatient);
        } else {
          // 追加モード: 新しい Patient を作成
          final newPatient = Patient(
            personalInfo: personalInfo,
            oneLineInfo: _oneLineInfoController.text,
            relatedContacts: relatedContacts,
            healthPromotion: healthPromotion,
            selfPerception: selfPerception,
          );
          await patientRepository.addPatient(newPatient);
        }
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          Navigator.of(context).pop(); // 前の画面に戻る
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
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildNullableCheckbox(
    String title,
    bool? currentValue,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormField<bool?>(
        builder: (FormFieldState<bool?> field) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              errorText: field.errorText,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Yes',
                  style: TextStyle(
                    color:
                        currentValue == true
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                ),
                Radio<bool?>(
                  value: true,
                  groupValue: currentValue,
                  onChanged: onChanged,
                ),
                Text(
                  'No',
                  style: TextStyle(
                    color:
                        currentValue == false
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                ),
                Radio<bool?>(
                  value: false,
                  groupValue: currentValue,
                  onChanged: onChanged,
                ),
                Text(
                  'Unknown',
                  style: TextStyle(
                    color:
                        currentValue == null
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                ),
                Radio<bool?>(
                  value: null,
                  groupValue: currentValue,
                  onChanged: onChanged,
                ),
              ],
            ),
          );
        },
        initialValue: currentValue,
        onSaved: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? '患者情報編集' : '患者情報入力')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSectionTitle('Basic Information'),
                  _buildTextFormField(_furiganaController, 'Furigana'),
                  _buildTextFormField(_nameController, 'Name'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _birthday == null
                                ? 'Date of Birth'
                                : 'Date of Birth: ${_birthday!.toLocal().toString().split(' ')[0]}',
                          ),
                        ),
                        if (_birthday != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Remove Date of Birth',
                            onPressed: () {
                              setState(() {
                                _birthday = null;
                              });
                            },
                          ),
                        ElevatedButton(
                          onPressed: () => _pickDate(context),
                          child: const Text('Select Date'),
                        ),
                      ],
                    ),
                  ),
                  _buildTextFormField(_addressController, 'Address'),
                  _buildTextFormField(
                    _telController,
                    'Phone Number',
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextFormField(
                    _oneLineInfoController,
                    'One Line Info',
                    keyboardType: TextInputType.multiline,
                  ),

                  _buildSectionTitle('Related Contacts'),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _relatedContacts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact ${index + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              _buildTextFormField(
                                _relatedContactControllers[index]['name']!,
                                'Name',
                              ),
                              _buildTextFormField(
                                _relatedContactControllers[index]['relationship']!,
                                'Relationship',
                              ),
                              _buildTextFormField(
                                _relatedContactControllers[index]['tel']!,
                                'Phone Number',
                                keyboardType: TextInputType.phone,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () => _removeRelatedContact(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Contact'),
                      onPressed: _addRelatedContact,
                    ),
                  ),
                  _buildSectionTitle('Health Promotion Information'),
                  _buildTextFormField(
                    _preHospitalCourseController,
                    'Pre-Hospital Course',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _chiefComplaintController,
                    'Chief Complaint',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _purposeController,
                    'Purpose of Admission',
                    keyboardType: TextInputType.multiline,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Current Illness - Doctor\'s Explanation and Patient\'s Perspective:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  _buildTextFormField(
                    _doctorOpinionController,
                    'Doctor\'s Explanation',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _principalOpinionController,
                    'Patient\'s Perspective',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _familyOpinionController,
                    'Family\'s Perspective',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _pastMedicalHistoryController,
                    'Past Medical History',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildNullableCheckbox(
                    'Medication Before Admission',
                    _isMedicinesExist,
                    (value) {
                      setState(() {
                        _isMedicinesExist = value;
                      });
                    },
                  ),
                  if (_isMedicinesExist == true)
                    _buildTextFormField(
                      _medicinesController,
                      'Medications',
                      keyboardType: TextInputType.multiline,
                    ),
                  _buildNullableCheckbox(
                    'Health Management Methods',
                    _isHealthManageMethodExist,
                    (value) {
                      setState(() {
                        _isHealthManageMethodExist = value;
                      });
                    },
                  ),
                  if (_isHealthManageMethodExist == true)
                    _buildTextFormField(
                      _healthManageMethodController,
                      'Health Management Methods',
                      keyboardType: TextInputType.multiline,
                    ),
                  _buildNullableCheckbox('Substances Use', _isSubstanceExist, (
                    value,
                  ) {
                    setState(() {
                      _isSubstanceExist = value;
                    });
                  }),
                  if (_isSubstanceExist == true) ...[
                    _buildTextFormField(
                      _alcoholPerDayController,
                      'Alcohol Consumption (cups/day)',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextFormField(
                      _cigarettsPerDayController,
                      'Cigarettes (sticks/day)',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextFormField(
                      _otherSubstanceController,
                      'Other Substances',
                    ),
                    _buildTextFormField(
                      _otherSubstanceRelatedInfoController,
                      'Other Substances Related Information',
                    ),
                  ],
                  _buildSectionTitle('Self-Perception and Self-Acceptance'),
                  _buildTextFormField(
                    _selfAwarenessController,
                    'How do you feel about yourself?',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _worriesController,
                    'Do you feel worry, anxiety, fear, depression, or despair?',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _howCanHelpController,
                    'What kind of help do you think you need?',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _painsController,
                    'Do you have any pain related to your body image?',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _selfPerceptionOthersController,
                    'Other (Self-Perception and Self-Acceptance)',
                    keyboardType: TextInputType.multiline,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
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
