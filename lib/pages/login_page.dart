import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/basic_text_box.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/components/navigation.dart';

import 'package:lofo/theme/light_theme.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController loginText = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _nonBouncyAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    const curve = Cubic(0.7, 0, 0.04, 1.05); // Customize this to your needs
    _animation = CurvedAnimation(parent: _controller, curve: curve)
      ..addListener(() {
        setState(() {});
      });
    const nonBouncyCurve = Cubic(1, 0.01, 0.54, 1);
    _nonBouncyAnimation =
        CurvedAnimation(parent: _controller, curve: nonBouncyCurve)
          ..addListener(() {
            setState(() {});
          });
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPaddingHeight = MediaQuery.of(context).padding.top;
    return Stack(children: [
      const Layout(),
      BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5 * (1 - _nonBouncyAnimation.value),
              sigmaY: 5 * (1 - _nonBouncyAnimation.value)),
          child: Container(
              color: backgroundAnimationColor
                  .withOpacity(0.5 * (1 - _animation.value).abs()))),
      Transform.translate(
        offset: Offset(
          0,
          -_animation.value *
              (screenHeight -
                  56.0 -
                  topPaddingHeight), // 56.0 is the height of the app bar
        ),
        child: loginPageContent(context, _controller),
      ),
      // loginPageContent(context),
    ]);
  }

  Scaffold loginPageContent(
      BuildContext context, AnimationController _controller) {
    return Scaffold(
      backgroundColor: Color.lerp(lightThemeScaffoldBackgroundColor,
          Colors.white, _nonBouncyAnimation.value),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                      tag: 'loginText',
                      child: Text('Welcome!', style: titleMedium)),
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

                        // Close keyboard
                        FocusScope.of(context).unfocus();

                        Future.delayed(const Duration(milliseconds: 500), () {
                          loginID = loginText.text;
                          performLogin(context, _controller);
                        });
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Opacity(
              opacity: _nonBouncyAnimation.value,
              child: appBar('Home', userImageExample))
        ],
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
