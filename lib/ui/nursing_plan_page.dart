import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:multiselect/multiselect.dart';

class NursingPlanPage extends StatefulWidget {
  const NursingPlanPage({Key? key}) : super(key: key);

  @override
  _NursingPlanPageState createState() => _NursingPlanPageState();
}

class _NursingPlanPageState extends State<NursingPlanPage>
    with SingleTickerProviderStateMixin {
  String? _selectedGender;
  List<String> _selectedHobbies = [];

  String? _selectedt4Item1;
  String? _selectedt4Item2;
  String? _selectedt4Item3;
  String? _selectedt4Item4;
  String? _selectedt4Item5;
  String? _selectedt4Item6;
  String? _selectedt4Item7;
  String? _selectedt4Item8;
  String? _selectedt4Item9;
  String? _selectedt4Item10;

  late TabController _tabController;
  // tab:看護計画用コントローラー
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _sController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _othersController = TextEditingController();

  // tab:個人情報管理用コントローラー
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _furiganaController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _admissionDateController =
      TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactRelationController =
      TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();

  // tab:health管理用コントローラー
  final TextEditingController _tab3C1 = TextEditingController();
  final TextEditingController _tab3C2 = TextEditingController();
  final TextEditingController _tab3C3 = TextEditingController();
  final TextEditingController _tab3C4 = TextEditingController();
  final TextEditingController _tab3C5 = TextEditingController();
  final TextEditingController _tab3C6 = TextEditingController();
  final TextEditingController _tab3C7 = TextEditingController();
  final TextEditingController _tab3C8 = TextEditingController();

  // tab:活動管理用コントローラー
  final TextEditingController _tab4C1 = TextEditingController();
  final TextEditingController _tab4C2 = TextEditingController();
  final TextEditingController _tab4C3 = TextEditingController();

  bool _isNursingPlanSaved = false;
  bool _isPersonalInfoSaved = false;
  bool _isHealthInfoSaved = false;
  bool _isActiveInfoSaved = false;

  bool get isNursingPlanFilled =>
      !_isNursingPlanSaved &&
      (_targetController.text.isNotEmpty ||
          _sController.text.isNotEmpty ||
          _oController.text.isNotEmpty ||
          _aController.text.isNotEmpty ||
          _pController.text.isNotEmpty ||
          _othersController.text.isNotEmpty);

  bool get isPersonalInfoFilled =>
      !_isPersonalInfoSaved &&
      (_nameController.text.isNotEmpty ||
          _furiganaController.text.isNotEmpty ||
          _selectedGender != null ||
          _birthController.text.isNotEmpty ||
          _addressController.text.isNotEmpty ||
          _phoneController.text.isNotEmpty ||
          _diagnosisController.text.isNotEmpty ||
          _admissionDateController.text.isNotEmpty ||
          _contactNameController.text.isNotEmpty ||
          _contactRelationController.text.isNotEmpty ||
          _contactPhoneController.text.isNotEmpty);

  bool get isHealthInfoFilled =>
      !_isHealthInfoSaved &&
      (_tab3C1.text.isNotEmpty ||
          _tab3C2.text.isNotEmpty ||
          _tab3C3.text.isNotEmpty ||
          _tab3C4.text.isNotEmpty ||
          _tab3C5.text.isNotEmpty ||
          _tab3C6.text.isNotEmpty ||
          _tab3C7.text.isNotEmpty ||
          _tab3C8.text.isNotEmpty ||
          _selectedHobbies.isNotEmpty);

  bool get isActiveInfoFilled =>
      !_isActiveInfoSaved &&
      (_selectedt4Item1 != null ||
          _selectedt4Item2 != null ||
          _selectedt4Item3 != null ||
          _selectedt4Item4 != null ||
          _selectedt4Item5 != null ||
          _selectedt4Item6 != null ||
          _selectedt4Item7 != null ||
          _selectedt4Item8 != null ||
          _selectedt4Item9 != null ||
          _selectedt4Item10 != null ||
          _tab4C1.text.isNotEmpty ||
          _tab4C2.text.isNotEmpty ||
          _tab4C3.text.isNotEmpty);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    // 看護計画用コントローラーの破棄
    _tabController.dispose();
    _targetController.dispose();
    _sController.dispose();
    _oController.dispose();
    _aController.dispose();
    _pController.dispose();
    _othersController.dispose();

    // 個人情報管理用コントローラーの破棄
    _nameController.dispose();
    _furiganaController.dispose();
    _genderController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _diagnosisController.dispose();
    _admissionDateController.dispose();
    _contactNameController.dispose();
    _contactRelationController.dispose();
    _contactPhoneController.dispose();

    // health管理用
    _tab3C1.dispose();
    _tab3C2.dispose();
    _tab3C3.dispose();
    _tab3C4.dispose();
    _tab3C5.dispose();
    _tab3C6.dispose();
    _tab3C7.dispose();
    _tab3C8.dispose();

    // 活動管理用
    _tab4C1.dispose();
    _tab4C2.dispose();
    _tab4C3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<ApplicationState>().screenId = 2;
          },
        ),
        title: Text('Nursing care plan creation'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: isNursingPlanFilled ? 'Plan *' : 'Plan'),
            Tab(text: isPersonalInfoFilled ? 'Information *' : 'Information'),
            Tab(text: isHealthInfoFilled ? 'Health *' : 'Health'),
            Tab(text: isActiveInfoFilled ? 'activities *' : 'Activities'),
            Tab(text: '栄養'),
            Tab(text: '排泄'),
            Tab(text: '知覚'),
            Tab(text: '安全'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildScrollableTabContent('Nurse Tab'),
          _buildPersonalInfoTab(),
          _buildHealthTab(),
          _buildActiveityTab(),
          Center(child: Text('Tab View')),
          Center(child: Text('Tab View')),
          Center(child: Text('Tab View')),
          Center(child: Text('Tab View')),
        ],
      ),
    );
  }

  // tab1
  Widget _buildScrollableTabContent(String tabName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            'Subjective Data',
            _sController,
            'Enter subjective information',
          ),
          _buildInputField(
            'Objective Data',
            _oController,
            'Enter objective information',
          ),
          _buildInputField(
            'Assessment',
            _aController,
            'Enter assessment information',
          ),
          _buildInputField('Plan', _pController, 'Enter plan information'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isNursingPlanSaved = true;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('保存しました')));
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  //tab2
  Widget _buildPersonalInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Name', _nameController, 'e.g., Taro Yamada'),
          SizedBox(height: 10),
          _buildInputField('Phonetic', _furiganaController, 'e.g., やまだたろう'),
          SizedBox(height: 10),
          buildDropdownField(
            label: 'Gender',
            items: ['Man', 'Woman', 'others'],
            selectedValue: _selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
                _isPersonalInfoSaved = false;
              });
            },
          ), // ← 性別はドロップダウンで
          SizedBox(height: 10),
          _buildInputField(
            'Date of Birth',
            _birthController,
            'e.g., 1990/01/01',
          ),
          _buildInputField(
            'Current Address',
            _addressController,
            'e.g., Shinjuku, Tokyo...',
          ),
          _buildInputField(
            'Phone Number',
            _phoneController,
            'e.g., 090-1234-5678',
          ),
          _buildInputField(
            'Diagnosis',
            _diagnosisController,
            'e.g., Hypertension',
          ),
          _buildInputField(
            'Date of Admission',
            _admissionDateController,
            'e.g., 2025/04/01',
          ),
          _buildInputField(
            'Emergency Contact (Name)',
            _contactNameController,
            'e.g., Hanako Yamada',
          ),
          _buildInputField(
            'Emergency Contact (Relationship)',
            _contactRelationController,
            'e.g., Wife',
          ),
          _buildInputField(
            'Emergency Contact (Phone Number)',
            _contactPhoneController,
            'e.g., 090-9876-5432',
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isPersonalInfoSaved = true;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('個人情報を保存しました')));
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  //tab3
  Widget _buildHealthTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField('Chief Complaint', _tab3C1, 'Please enter'),
          _buildInputField('Purpose', _tab3C2, 'Please enter'),
          const SizedBox(height: 30),
          const Text(
            'Perception of Diagnosis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          _buildInputField('Doctor', _tab3C3, 'Please enter'),
          _buildInputField('Patient', _tab3C4, 'Please enter'),
          _buildInputField('Family', _tab3C5, 'Please enter'),
          const SizedBox(height: 20),
          _buildInputField('Medical History', _tab3C6, 'Please enter'),
          _buildInputField('Medications', _tab3C7, 'Please enter'),
          _buildInputField('Health Management Method', _tab3C8, 'Please enter'),
          buildMultiSelectField(
            label: 'Hobbies',
            items: ['Alcohol', 'Smoking'],
            selectedValues: _selectedHobbies,
            onSelectionChanged: (List<String> newValues) {
              setState(() {
                _selectedHobbies = newValues;
                _isPersonalInfoSaved = false; // ← Required
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isHealthInfoSaved = true;
              });
            },
            child: Text('Save'),
          ),
          // 他のコンテンツをここに追加
        ],
      ),
    );
  }

  // tab4
  Widget _buildActiveityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDropdownField(
            label: 'Meals',
            items: [
              'Can eat independently',
              'Can eat with assistive devices',
              'Can eat with setup',
              'Cannot eat independently',
            ],
            selectedValue: _selectedt4Item1,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item1 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Bathing',
            items: [
              'Can bathe independently',
              'Can take a shower independently',
              'Cannot bathe independently',
            ],
            selectedValue: _selectedt4Item2,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item2 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Dressing',
            items: [
              'Can do everything independently',
              'Can put on/take off upper garments',
              'Can put on/take off pants',
              'Can dress/undress except buttons/hooks',
              'Cannot dress/undress independently',
            ],
            selectedValue: _selectedt4Item3,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item3 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Grooming',
            items: [
              'Can do everything independently',
              'Can wash face',
              'Can comb hair',
              'Cannot groom independently',
            ],
            selectedValue: _selectedt4Item4,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item4 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Toileting',
            items: [
              'Can use toilet independently',
              'Can use portable toilet',
              'Can use bedpan/urinal independently',
              'Cannot perform toileting independently',
            ],
            selectedValue: _selectedt4Item5,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item5 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Bed Mobility',
            items: [
              'Can move freely in bed',
              'Can sit up',
              'Can sit up with support',
              'Can turn over',
              'Can turn over with support',
              'Cannot move independently',
            ],
            selectedValue: _selectedt4Item6,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item6 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Transfers',
            items: [
              'Can move freely',
              'Can transfer with devices',
              'Requires supervision',
              'Requires partial assistance',
              'Fully dependent',
              'Makes no attempt to move',
            ],
            selectedValue: _selectedt4Item7,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item7 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Wheelchair Transfer',
            items: [
              'Can transfer independently',
              'Cannot transfer independently',
            ],
            selectedValue: _selectedt4Item8,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item8 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          buildDropdownField(
            label: 'Walking',
            items: [
              'Can walk',
              'Can walk with cane/walker',
              'Can walk holding on to something',
              'Cannot walk',
              'Makes no attempt to walk',
            ],
            selectedValue: _selectedt4Item9,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item9 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          _buildInputField('Sleep Duration', _tab4C1, 'Please enter'),
          _buildInputField('Bedtime', _tab4C2, 'Please enter'),
          _buildInputField('Wake-up Time', _tab4C3, 'Please enter'),
          buildDropdownField(
            label: 'Do you get enough sleep?',
            items: ['Yes', 'No'],
            selectedValue: _selectedt4Item10,
            onChanged: (String? newValue) {
              setState(() {
                _selectedt4Item10 = newValue;
                _isActiveInfoSaved = false;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isActiveInfoSaved = true;
              });
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hintText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) {
            setState(() {
              _isPersonalInfoSaved = false;
            });
          },
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget buildDropdownField({
    required String label,
    required List<String> items,
    required String? selectedValue,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'please select',
          ),
          items:
              items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: onChanged, // ← 決定的ポイント
        ),
      ],
    );
  }

  Widget buildMultiSelectField({
    required String label,
    required List<String> items,
    required List<String> selectedValues,
    required Function(List<String>) onSelectionChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropDownMultiSelect<String>(
          options: items,
          selectedValues: selectedValues,
          onChanged: onSelectionChanged,
          whenEmpty: 'please select',
        ),
      ],
    );
  }
}
