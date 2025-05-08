import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';

class Nursing_info extends StatefulWidget {
  const Nursing_info({Key? key}) : super(key: key); // ★ここ追加！

  @override
  _Infomation createState() => _Infomation();
}

class _Infomation extends State<Nursing_info>
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
            context.read<ApplicationState>().screenId =
                context.read<ApplicationState>().oldscreenId;
          },
        ),
        title: Text('Nursing Information'),
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
          Center(child: Text('Tab 2 View')),
          Center(child: Text('Tab 3 View')),
        ],
      ),
    );
  }
}
