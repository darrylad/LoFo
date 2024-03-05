import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/basic_text_box.dart';
import 'package:lofo/components/button.dart';

import 'package:lofo/theme/light_theme.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(tag: 'loginText', child: Text('Welcome!', style: titleMedium)),
            const SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: BasicTextBox(
                  maxLength: 30,
                  labelText: 'Login ID',
                  textController: loginText),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Hero(
                tag: 'loginButton',
                child: BasicButton.primaryButton('Login', () {
                  // loginID = 'ex220003002@iiti.ac.in';
                  // loginID = 'meow';
                  loginID = loginText.text;
                  performLogin(context);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFailedPage extends StatefulWidget {
  const LoginFailedPage({super.key});

  @override
  State<LoginFailedPage> createState() => _LoginFailedPageState();
}

class _LoginFailedPageState extends State<LoginFailedPage> {
  Timer? _timer;
  int _remainingTime = 5;

  void startCloseTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingTime == 1) {
        SystemNavigator.pop();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startCloseTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.errorContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: 'loginText',
            child: Text(
              'Invalid Login',
              style: TextStyle(color: warningPrimaryColor, fontSize: 40),
            ),
          ),
          const SizedBox(height: 200),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Hero(
              tag: 'loginButton',
              child: BasicButton.warningPrimaryButton('Exit', () {
                SystemNavigator.pop();
              }),
            ),
          ),
          const SizedBox(height: 50),
          Opacity(
              opacity: 0.1,
              child: Text('$_remainingTime',
                  style: TextStyle(color: warningPrimaryColor))),
        ],
      ),
    );
  }
}
