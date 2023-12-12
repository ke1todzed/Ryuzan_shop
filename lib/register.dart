import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryozan_shop/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'cache.dart';
import 'db.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isButtonPressed = false;
  bool inProgress = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _email = '';
  String _password = '';
  bool showLogin = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: <Widget>[
                  _getHeader(),
                  _getInputs(_emailController, _passwordController),
                  _getSignUp(context),
                  _getBottomRow(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List> _registerButtonAction() async {
    inProgress = true;
    _email = _emailController.text;
    _password = _passwordController.text;
    SupabaseAuthRepository sar = SupabaseAuthRepository();

    if (_email.isEmpty || _password.isEmpty) return [false,"Введите email и пароль"];

    String result = await sar.signUpEmailAndPassword(
        _email.trim(), _password.trim());
    CurrentUserData.email = _email.trim();
    if (CurrentUserData.email == "") {
      inProgress = true;
      return [false, result];
    } else if(result == "1") {
      inProgress = true;
      return [true, result];
    }else{
      inProgress = true;
      return [false, result];
    }
  }

  _getHeader() {
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: const Text(
          'Регистрация аккаунта',
          style: TextStyle(color: Colors.white, fontSize: 37),
        ),
      ),
    );
  }

  _getInputs(emailController, passwordController) {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          TextField(
            cursorColor: Colors.white,
            controller: emailController,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: 'E-mail',
                labelStyle: const TextStyle(color: Colors.white,fontSize: 16)),
            style: (const TextStyle(color: Colors.white,fontSize: 18)),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            cursorColor: Colors.white,
            controller: passwordController,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: 'Пароль',
              labelStyle: const TextStyle(color: Colors.white,fontSize: 16),
            ),
            style: (const TextStyle(color: Colors.white,fontSize: 18)),
            obscureText: true,
            obscuringCharacter: '*',
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  _getSignUp(context) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Регистрация',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          Container(
              child: IconButton(
                  onPressed: isButtonPressed == false
                      ? () async {
                          setState(() {
                            isButtonPressed = true;
                          });
                          List ans = await _registerButtonAction();
                          inProgress = false;
                          if (ans[0]) {
                            EasyLoading.show();
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            LocalDataAnalyse LDA = LocalDataAnalyse(sp: sp);
                            await ProductInfo.getData();
                            LDA.setLoginStatus(
                                "1",
                                _emailController.text.trim(),
                                _passwordController.text.trim());
                            CurrentUserData.email =
                                _emailController.text.trim();
                            CurrentUserData.pass =
                                _passwordController.text.trim();
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (r) => false);
                            EasyLoading.dismiss();
                            EasyLoading.removeAllCallbacks();
                            _emailController.clear();
                            _passwordController.clear();
                          } else if (inProgress == false) {
                            setState(() {
                              isButtonPressed = false;
                            });
                            String e = ans[1];
                            if (_passwordController.text.length < 6) {
                              e = "Пароль должень быть больше 5 символов";
                            }
                            Fluttertoast.showToast(
                                msg: e,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.deepOrange,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            _passwordController.clear();
                          }
                        }
                      : null,
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_forward,color: Colors.white))),
        ],
      ),
    );
  }

  _getBottomRow(context) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: const Text(
              "Вход",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
