import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';
import 'package:solution_challenge_tcu_2025/data/patient.dart';
import 'package:solution_challenge_tcu_2025/data/patient_repository.dart';

class NursingInfoPage extends StatefulWidget {
  const NursingInfoPage({Key? key}) : super(key: key); // ★ここ追加！

  @override
  _NursingInfoPageState createState() => _NursingInfoPageState();
}

class _NursingInfoPageState extends State<NursingInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        title: const Text('Nursing Information'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'doctor'),
            Tab(text: 'nurse'),
            Tab(text: 'inspection'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('Tab 1 View')),
          NestedTabWidget(),
          Center(child: Text('Tab 3 View')),
        ],
      ),
    );
  }
}

class NestedTabWidget extends StatefulWidget {
  const NestedTabWidget({Key? key}) : super(key: key);

  @override
  State<NestedTabWidget> createState() => _NestedTabWidgetState();
}

class _NestedTabWidgetState extends State<NestedTabWidget> with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _innerTabController,
          tabs: const [
            Tab(text: 'SOAP'),
            Tab(text: '看護計画'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              Center(child: Text('SOAP内容')),
              Center(child: Text('看護計画の内容')),
            ],
          ),
        ),
      ],
    );
  }
}
