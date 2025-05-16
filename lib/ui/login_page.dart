import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medflow/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  String _errorMessage = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firebaseState = context.watch<FirebaseAuthState>();

    Widget insideWidget;
    if (!firebaseState.loggedIn) {
      // When user is NOT logged in
      insideWidget = Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  RegExp emailRegex = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (value == null ||
                      value.isEmpty ||
                      !emailRegex.hasMatch(value)) {
                    return 'Please enter the valid email!';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the password!';
                  }
                  return null;
                },
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
            Center(child: Text(_errorMessage)),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() => _errorMessage = '');
                  if (_formKey.currentState!.validate()) {
                    loginWithPassword(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    ).then(
                      (msg) => {
                        setState(() {
                          _errorMessage = msg;
                        }),
                      },
                    );
                  }
                },
                child: Text('Login'),
              ),
            ),
          ],
        ),
      );
    } else {
      // When user is logged in.
      insideWidget = Column(
        children: [
          Text('Hello, ${FirebaseAuth.instance.currentUser?.email}'),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: insideWidget,
        ),
      ),
    );
  }

  Future<String> loginWithPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'user-not-found' ||
          e.code == 'wrong-password') {
        return 'Email or Password is wrong.';
      }
      print('Exception: $e');
    }
    return '';
  }
}
