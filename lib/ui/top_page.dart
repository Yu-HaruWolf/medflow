import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medflow/app_state.dart';
import 'package:medflow/ui/login_page.dart';
import 'package:medflow/ui/patients_list_page.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({required this.title});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  var patientIndex = 0;
  @override
  Widget build(BuildContext context) {
    final firebaseAuthState = context.watch<FirebaseAuthState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 62, 183, 220),
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: firebaseAuthState.loggedIn ? TopPageMenu() : LoginPage(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 92, 118),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  if (firebaseAuthState.loggedIn)
                    Text(
                      '${FirebaseAuth.instance.currentUser?.email}',
                      style: TextStyle(color: Colors.white),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop(); // close drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TopPageMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => PatientsListPage()));
                },
                child: const Text('Patients list'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
