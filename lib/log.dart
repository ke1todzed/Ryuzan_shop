import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryozan_shop/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cache.dart';
import 'db.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  _getLogIn(context),
                  _getBottomRow(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<List> _loginButtonAction() async {
    inProgress = true;
    _email = _emailController.text;
    _password = _passwordController.text;
    SupabaseAuthRepository sar = SupabaseAuthRepository();

    if (_email.isEmpty || _password.isEmpty) return [false,"0"];

    String result = await sar.signInEmailAndPassword(
        _email.trim(), _password.trim());
    if (result == "1") {
      return [true,"1"];
    } else {
      return [false,result];
    }

  }

  _getHeader() {
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.bottomLeft,
        child: const Text(
          'Добро пожаловать',
          style: TextStyle(color: Colors.white, fontSize: 37),
        ),
      ),
    );
  }

  _getInputs(emailController, passwordController) {
    return Expanded(
        flex: 4,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          TextField(
            cursorColor: Colors.white,
            controller: emailController,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
                ),
                labelText: 'E-Mail',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.background),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
                )),
            style: (const TextStyle(color: Colors.white,fontSize: 18)),
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            cursorColor: Colors.white,
            controller: passwordController,
            decoration: InputDecoration(
                labelText: 'Пароль',
                labelStyle: const TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
            style: (const TextStyle(color: Colors.white,fontSize: 18)),
            obscureText: true,
            obscuringCharacter: '*',
          ),
        ]));
  }

  _getLogIn(context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text(
            'Вход',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
          ),
          Container(
              child: IconButton(
                  onPressed: isButtonPressed == false
                      ? () async {
                          setState(() {
                            isButtonPressed = true;
                          });
                          List ans = await _loginButtonAction();
                          inProgress = false;
                          if (ans[0]) {
                            await ProductInfo.getData();
                            await ProductInfo.getCart(
                                Supabase.instance.client.auth.currentUser?.id);
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            LocalDataAnalyse LDA = LocalDataAnalyse(sp: sp);
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
                            if (ans[1] != "0") {
                              Fluttertoast.showToast(
                                  msg: ans[1],
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.deepOrange,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/register');
              _emailController.clear();
              _passwordController.clear();
            },
            child: const Text(
              'Регистрация',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/forpass');
                _emailController.clear();
                _passwordController.clear();
              },
              child: const Text(
                'Забыли пароль',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline),
              ))
        ],
      ),
    );
  }
}
