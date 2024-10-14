import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';

String? loginInformatoryText;
String? loginButtonText;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginText =
      TextEditingController(text: securityAccountEmail);

  // late AnimationController _animationController;
  // late Animation<double> _animation;
  // late Animation<double> _nonBouncyAnimation;

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     duration: const Duration(milliseconds: 900),
  //     vsync: this,
  //   );
  //   const curve = Cubic(0.7, 0, 0.04, 1.05); // Customize this to your needs
  //   _animation = CurvedAnimation(parent: _animationController, curve: curve)
  //     ..addListener(() {
  //       setState(() {});
  //     });
  //   const nonBouncyCurve = Cubic(1, 0.01, 0.54, 1);
  //   _nonBouncyAnimation =
  //       CurvedAnimation(parent: _animationController, curve: nonBouncyCurve)
  //         ..addListener(() {
  //           setState(() {});
  //         });
  //   // _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
  //   //   ..addListener(() {
  //   //     setState(() {});
  //   //   });
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // double screenHeight = MediaQuery.of(context).size.height;
    // double topPaddingHeight = MediaQuery.of(context).padding.top;

    String informatoryText = loginInformatoryText ??
        'To continue, we need to verify that you belong to Indian Institute of Technology Indore. On the next screen, choose your institute\'s ID. \n \n Your account will be unaffected, and no data will be stored on your account.';
    String buttonText = loginButtonText ?? 'Verify identity with Google';

    return loginPageContent(context, informatoryText, buttonText);

    // return Stack(children: [
    //   const Layout(),
    //   AnimatedBuilder(
    //     animation: _nonBouncyAnimation,
    //     builder: (BuildContext context, Widget? child) {
    //       return BackdropFilter(
    //         filter: ImageFilter.blur(
    //             sigmaX: 5 * (1 - _nonBouncyAnimation.value),
    //             sigmaY: 5 * (1 - _nonBouncyAnimation.value)),
    //         child: Container(
    //             color: backgroundAnimationColor
    //                 .withOpacity(0.5 * (1 - _nonBouncyAnimation.value).abs())),
    //       );
    //     },
    //   ),
    //   AnimatedBuilder(
    //     animation: _animation,
    //     builder: (BuildContext context, Widget? child) {
    //       return Transform.translate(
    //         offset: Offset(
    //           0,
    //           -_animation.value *
    //               (screenHeight -
    //                   56.0 -
    //                   topPaddingHeight), // 56.0 is the height of the app bar
    //         ),
    //         child: loginPageContent(context, _animationController),
    //       );
    //     },
    //   )
    //   // loginPageContent(context),
    // ]);
  }

  Scaffold loginPageContent(
      BuildContext context, String informatoryText, String buttonText) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome!', style: themeData.textTheme.titleMedium),
            const SizedBox(height: 50),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50.0),
            //   child: BasicTextBox(
            //       hintText: 'this field is depricated',
            //       maxLength: 30,
            //       maxLines: 1,
            //       // labelText: 'Login ID',
            //       textController: loginText),
            // ),
            // const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  // 'To continue, we need to verify that you belong to Indian Institute of Technology Indore. On the next screen, choose your institute\'s ID. \n \n Your account will be unaffected, and no data will be stored on your account.',
                  informatoryText,
                  style: TextStyle(
                      color: themeData.colorScheme.secondary, fontSize: 16),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Hero(
                tag: 'loginButton',
                child: BasicButton.primaryButton(buttonText, () {
                  // loginID = 'ex220003002@iiti.ac.in';
                  // loginID = 'meow';

                  // Close keyboard
                  // FocusScope.of(context).unfocus();

                  // Future.delayed(const Duration(milliseconds: 500), () {
                  // loginID = loginText.text;
                  debugPrint('Login ID: $loginID');
                  performLogin(context, this);
                  // });
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
      backgroundColor: themeData.colorScheme.errorContainer,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Invalid Login',
            style: TextStyle(
                color: themeData.colorScheme.onErrorContainer, fontSize: 40),
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
                  style: TextStyle(
                      color: themeData.colorScheme.onErrorContainer,
                      fontSize: 20))),
        ],
      ),
    );
  }
}
