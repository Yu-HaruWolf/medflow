import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solution_challenge_tcu_2025/app_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  final _UserController = TextEditingController();
  final _PasswardcCntroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _UserController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ユーザー名が入力されていません!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'ユーザー名を入力してください',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: _PasswardcCntroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'パスワードが入力されていません!';
                      }
                      return null;
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            })),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      String inputUser = _UserController.text;
                      String inputPass = _PasswardcCntroller.text;

                      String correctUser = "tcu";
                      String correctPass = "0000";

                      if(inputUser == correctUser && inputPass == correctPass){
                        context.read<ApplicationState>().screenId = 1;
                      }
                    }, child: Text('ログイン')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}