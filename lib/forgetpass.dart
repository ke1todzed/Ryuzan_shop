import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ryozan_shop/auth.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({Key? key}) : super(key: key);

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailController = TextEditingController();

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
                  _getInputs(),
                  _getForget(context)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getInputs() {
    return Expanded(
      flex: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
              cursorColor: Colors.white,
              controller: _emailController,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.background),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.background),
                  ),
                  labelText: 'E-mail',
                  labelStyle: Theme.of(context).textTheme.displaySmall),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 18)),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  _getHeader() {
    return Expanded(
      flex: 3,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text('Сбросить пароль',
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 37)),
      ),
    );
  }

  _getForget(context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
              _emailController.clear();
            },
            child: const Text(
              "Вспомнили?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline),
            ),
          ),
          Container(
              child: IconButton(
                  onPressed: () {
                    if (_emailController.text.trim() != "") {
                      SupabaseAuthRepository sar = SupabaseAuthRepository();
                      sar.resetPassword(_emailController.text.trim());
                      Fluttertoast.showToast(
                          msg: "Письмо на эл.почту отправлено!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.deepOrange,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushNamed(context, '/login');
                      _emailController.clear();
                    } else {
                      Fluttertoast.showToast(
                          msg: "Введите E-mail!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.deepOrange,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      _emailController.clear();
                    }
                  },
                  iconSize: 40,
                  icon: const Icon(Icons.arrow_forward,
                      color: Colors.white))),
        ],
      ),
    );
  }
}
