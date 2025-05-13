import 'package:flutter/material.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // loading state

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

  @override
  void initState() {
    super.initState();
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

    for (var controllers in _relatedContactControllers) {
      controllers.forEach((key, controller) => controller.dispose());
    }
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday ?? DateTime(1980, 1, 1), // Default initial date
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
      // Assuming RelatedContact constructor has no arguments or all optional
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
      final patient = Patient(
        personalInfo: PersonalInfo(
          furigana: _furiganaController.text,
          name: _nameController.text,
          birthday: _birthday,
          address: _addressController.text,
          tel: _telController.text,
        ),
        relatedContacts: _relatedContacts,
        healthPromotion: HealthPromotion(
          preHospitalCourse: _preHospitalCourseController.text,
          chiefComplaint: _chiefComplaintController.text,
          purpose: _purposeController.text,
          opinions: {
            // opinions の各値も null になりうる
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
        ),
        selfPerception: SelfPerception(
          selfAwareness: _selfAwarenessController.text,
          worries: _worriesController.text,
          howCanHelp: _howCanHelpController.text,
          pains: _painsController.text,
          others: _selfPerceptionOthersController.text,
        ),
      );
      final patientRepository = PatientRepository();
      try {
        await patientRepository.addPatient(patient);
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
        validator: (value) {
          // Removed required check to allow blanks
          // 数値フィールドの場合のバリデーションは残しても良い
          if (keyboardType == TextInputType.number &&
              value != null &&
              value.trim().isNotEmpty && // trim() を追加して空白のみの入力をチェック
              int.tryParse(value.trim()) == null) {
            return '有効な数値を入力してください';
          }
          return null; // 常にnullを返し、バリデーションエラーとしない
        },
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
                  'はい',
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
                  'いいえ',
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
                  '不明',
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
        onSaved: onChanged, // onChanged を直接 onSaved に渡す
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Information Input')),
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

                  _buildNullableCheckbox('入院までの使用薬剤の有無', _isMedicinesExist, (
                    value,
                  ) {
                    setState(() {
                      _isMedicinesExist = value;
                    });
                  }),
                  if (_isMedicinesExist == true)
                    _buildTextFormField(
                      _medicinesController,
                      '使用薬剤',
                      keyboardType: TextInputType.multiline,
                    ),

                  _buildNullableCheckbox(
                    '健康管理の方法の有無',
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
                      '健康管理の方法',
                      keyboardType: TextInputType.multiline,
                    ),

                  _buildNullableCheckbox('嗜好品の有無', _isSubstanceExist, (value) {
                    setState(() {
                      _isSubstanceExist = value;
                    });
                  }),
                  if (_isSubstanceExist == true) ...[
                    _buildTextFormField(
                      _alcoholPerDayController,
                      'アルコール摂取量 (杯/日)',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextFormField(
                      _cigarettsPerDayController,
                      'タバコ本数 (本/日)',
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextFormField(_otherSubstanceController, 'その他嗜好品'),
                    _buildTextFormField(
                      _otherSubstanceRelatedInfoController,
                      'その他嗜好品関連情報',
                    ),
                  ],

                  // SelfPerception 入力欄
                  _buildSectionTitle('自己認識・自己受容（Self-Perception）'),
                  _buildTextFormField(
                    _selfAwarenessController,
                    '自分のことをどう思っていますか',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _worriesController,
                    'いま、悩みや不安、恐怖、抑うつ、絶望を感じていますか',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _howCanHelpController,
                    '悩みや不安に対し、手助けできることはありますか',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _painsController,
                    '身体の外観の痛みはありますか',
                    keyboardType: TextInputType.multiline,
                  ),
                  _buildTextFormField(
                    _selfPerceptionOthersController,
                    'その他（自己認識・自己受容）',
                    keyboardType: TextInputType.multiline,
                  ),

                  // _buildSectionTitle('看護計画'), // NursingPlan を使う場合はコメント解除
                  // _buildTextFormField(_nursingPlanContentController, '看護計画の内容', keyboardType: TextInputType.multiline),
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
