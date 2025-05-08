import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';

class NursingPlanPage extends StatefulWidget {
  const NursingPlanPage({Key? key}) : super(key: key);

  @override
  _NursingPlanPageState createState() => _NursingPlanPageState();
}

class _NursingPlanPageState extends State<NursingPlanPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  final TextEditingController _sController = TextEditingController();
  final TextEditingController _oController = TextEditingController();
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  bool _isNursingPlanSaved = false;

  bool get isNursingPlanFilled =>
      !_isNursingPlanSaved &&
      (_sController.text.isNotEmpty ||
          _oController.text.isNotEmpty ||
          _aController.text.isNotEmpty ||
          _pController.text.isNotEmpty);

  @override
  void dispose() {
    _tabController.dispose();
    _sController.dispose();
    _oController.dispose();
    _aController.dispose();
    _pController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                context.read<ApplicationState>().screenId = 2;
              },
            ),
            title: const Text(
              'Nursing Plan',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Doctor'),
                Tab(text: 'Nurse'),
                Tab(text: 'Inspection'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'memo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 高さ固定のTextField（スクロール対応）
                      SizedBox(
                        height: 300, // 好みの高さに調整可能
                        child: TextField(
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter your medical details here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 保存ボタン
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // 保存処理
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('data saved')),
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _NestedTabWidget(
                sController: _sController,
                oController: _oController,
                aController: _aController,
                pController: _pController,
                isNursingPlanSaved: _isNursingPlanSaved,
                onSaved: () {
                  setState(() {
                    _isNursingPlanSaved = true;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVitalInput('Temperature'),
                    const SizedBox(height: 10),
                    _buildVitalInput('Heart Rate'),
                    const SizedBox(height: 10),
                    _buildVitalInput('Blood Pressure'),
                    const SizedBox(height: 10),
                    _buildVitalInput('Respiratory Rate'),
                    const SizedBox(height: 20), // 少しスペース
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // 保存処理をここに追加
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('data saved')),
                          );
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalInput(String label) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        const SizedBox(width: 50),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true, // 高さを少し抑える
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NestedTabWidget extends StatefulWidget {
  final TextEditingController sController;
  final TextEditingController oController;
  final TextEditingController aController;
  final TextEditingController pController;
  final bool isNursingPlanSaved;
  final VoidCallback onSaved;

  const _NestedTabWidget({
    super.key,
    required this.sController,
    required this.oController,
    required this.aController,
    required this.pController,
    required this.isNursingPlanSaved,
    required this.onSaved,
  });

  @override
  State<_NestedTabWidget> createState() => _NestedTabWidgetState();
}

class _NestedTabWidgetState extends State<_NestedTabWidget>
    with TickerProviderStateMixin {
  late TabController _innerTabController;

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  bool get isFilled =>
      !widget.isNursingPlanSaved &&
      (widget.sController.text.isNotEmpty ||
          widget.oController.text.isNotEmpty ||
          widget.aController.text.isNotEmpty ||
          widget.pController.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: [Tab(text: isFilled ? 'SOAP *' : 'SOAP'), Tab(text: '看護計画')],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [_buildSOAPTab(), const Center(child: Text('内タブBの内容'))],
          ),
        ),
      ],
    );
  }

  Widget _buildSOAPTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInputField(
            'Subjective Data',
            widget.sController,
            'Enter subjective information',
          ),
          _buildInputField(
            'Objective Data',
            widget.oController,
            'Enter objective information',
          ),
          _buildInputField(
            'Assessment',
            widget.aController,
            'Enter assessment information',
          ),
          _buildInputField(
            'Plan',
            widget.pController,
            'Enter plan information',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSaved();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('data saved')));
            },
            child: const Text('Save'),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
