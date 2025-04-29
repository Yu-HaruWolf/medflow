import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';

class Nursing_plan extends StatefulWidget {
  const Nursing_plan({Key? key}) : super(key: key);

  @override
  _Planing createState() => _Planing();
}

class _Planing extends State<Nursing_plan> with SingleTickerProviderStateMixin {
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
            context.read<ApplicationState>().screenId =
                context.read<ApplicationState>().oldscreenId;
          },
        ),
        title: Text('Nursing care plan creation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'doctor'),
            Tab(text: 'nurse'),
            Tab(text: 'inspection'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Tab 1 View')),
          _buildScrollableTabContent('Nurse Tab'),
          Center(child: Text('Tab 3 View')),
        ],
      ),
    );
  }

  // スクロール可能なタブの内容を構築
  Widget _buildScrollableTabContent(String tabName) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelAndTextField('target', 'targe', 'Enter information'),
          SizedBox(height: 10),
          _buildLabelAndTextField('S', 'Subjective', 'Enter subjective information'),
          SizedBox(height: 10),
          _buildLabelAndTextField('O', 'Objective', 'Enter objective information'),
          SizedBox(height: 10),
          _buildLabelAndTextField('A', 'Assessment', 'Enter assessment information'),
          SizedBox(height: 10),
          _buildLabelAndTextField('P', 'Plan', 'Enter plan information'),
          SizedBox(height: 20),
          _buildLabelAndTextField('others', 'others', 'Enter'),
          SizedBox(height: 20),
          //Text(tabName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLabelAndTextField(String label, String hint, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            labelText: hint,
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}

