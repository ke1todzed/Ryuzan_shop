import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ryozan_shop/forgetpass.dart';
import 'package:ryozan_shop/log.dart';
import 'package:ryozan_shop/register.dart';
import 'package:ryozan_shop/scroll_behavior.dart';
import 'package:ryozan_shop/start.dart';
import 'package:ryozan_shop/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'first.dart';
import 'logreg.dart';

const sburl = "https://kbhfwdxktibqslpkqpkj.supabase.co";
const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtiaGZ3ZHhrdGlicXNscGtxcGtqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE2MDU5MzEsImV4cCI6MjAxNzE4MTkzMX0.Ji89I1qlefTHNClFZ7JxVKLap9CJQgo0aIlPybQ09Ds';


Future<void> main() async {
  ///Делает приложение неповоротным на экране
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Supabase.initialize(
    url: sburl,
    anonKey: anonKey,
  );

  runApp(MaterialApp(
    scrollBehavior: MyBehavior(),
    builder: EasyLoading.init(),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => const First(),
      '/home': (context) => const Start(),
      '/logreg': (context) => const LogReg(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const SignUpPage(),
      '/forpass': (context) => const ForgetPass(),
    },
    theme: theme(),
  ));
}

class CurrentUserData {
  static String email = "";
  static String name = "";
  static String pass = "";
}
