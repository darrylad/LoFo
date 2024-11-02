import 'package:flutter/material.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/onboarding/hi_there.dart';
import 'package:lofo/onboarding/on_boarding_button.dart';
import 'package:lofo/theme/dark_theme.dart';

class Page4Notifications extends StatefulWidget {
  const Page4Notifications({super.key});

  @override
  State<Page4Notifications> createState() => _Page4NotificationsState();
}

class _Page4NotificationsState extends State<Page4Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 64, 161),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 200),
                    Image.asset('assets/onboarding/Page4noti.png'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Get notified about new posts",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: fonts[0],
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Text(
                  'Notifications need to first be enabled from the "more" page',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                OnBoardingButton(
                    onPressed: () {
                      hasNotPlayedOnboarding = false;
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              // return const LoginPage();
                              return const LoginVerification();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ));
                    },
                    buttonText: "Done"),
                const SizedBox(height: 50),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
