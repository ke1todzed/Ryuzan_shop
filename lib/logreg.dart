import 'package:flutter/material.dart';

class LogReg extends StatefulWidget {
  const LogReg({Key? key}) : super(key: key);

  @override
  State<LogReg> createState() => _LogRegState();
}

class _LogRegState extends State<LogReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 120)),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.login,
              size: 150,
              color: Colors.white,
            ),
          ]),
          const Padding(padding: EdgeInsets.only(top: 80)),
          Text(
              'Регистация и\nвход',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 35,color: Colors.white,)
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 50)),
          SizedBox(
            height: 40,
            width: 150,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Регистрация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 50)),
          SizedBox(
            height: 40,
            width: 150,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.red)),
              child: const Text(
                'Вход',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      )
      ),
    );
  }
}


