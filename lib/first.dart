import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ryozan_shop/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cache.dart';
import 'db.dart';
import 'main.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool showLoading = false;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    return Scaffold(
        backgroundColor: const Color(0xFF333333),
        body: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(padding: EdgeInsets.only(top: height / 6.5)),
            Image.asset('assets/logo.jpg'),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Padding(padding: EdgeInsets.only(top: 90)),
            _getIconButton(context),
            _getLoading(context),
          ]))
        ]));
  }

  _getIconButton(context) {
    return Visibility(
        visible: !inProgress,
        child: IconButton(
          icon: const Icon(Icons.east),
          iconSize: 65,
          color: Colors.white,
          onPressed: inProgress == false
              ? () async {
                  setState(() {
                    showLoading = true;
                    inProgress = true;
                  });
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  LocalDataAnalyse LDA = LocalDataAnalyse(sp: sp);
                  String status = await LDA.getLoginStatus();
                  if (status == "1") {
                    String userLogin = await LDA.getUserLogin();
                    CurrentUserData.email = userLogin;
                    String userPassword = await LDA.getUserPassword();
                    CurrentUserData.pass = userPassword;
                    CurrentUserData.name = "dasdsadas";
                    SupabaseAuthRepository sar = SupabaseAuthRepository();
                    String ans = await sar.signInEmailAndPassword(
                        userLogin.trim(), userPassword.trim());
                    if (ans == "1") {
                      await ProductInfo.getData();
                      await ProductInfo.getCart(
                          Supabase.instance.client.auth.currentUser?.id);
                      inProgress = false;
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/home", (r) => false);
                    } else {
                      inProgress = false;
                      Navigator.pushReplacementNamed(context, '/logreg');
                    }
                  } else {
                    inProgress = false;
                    Navigator.pushReplacementNamed(context, '/logreg');
                  }
                }
              : null,
        ));
  }

  _getLoading(context) {
    return Visibility(
        visible: showLoading,
        child: LoadingAnimationWidget.waveDots(color: Colors.white, size: 60));
  }
}
