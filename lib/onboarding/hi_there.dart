import 'package:flutter/material.dart';
import 'package:lofo/main.dart';
import 'package:lofo/onboarding/on_boarding_button.dart';
import 'package:lofo/onboarding/Page1_see_what_people.dart';

bool hasNotPlayedOnboarding = true;

class HiThere extends StatelessWidget {
  const HiThere({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Text("Hi there!",
                style: themeData.textTheme.titleMedium
                    ?.copyWith(color: themeData.colorScheme.primary)),
            const Expanded(child: SizedBox()),
            Text(
              "Lets take a quick tour",
              style: themeData.textTheme.bodyLarge?.copyWith(
                color: themeData.colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 40),
            OnBoardingButton(
              buttonText: "Continue",
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        // return const LoginPage();
                        return const PostsIntro();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ));
              },
            ),
            const SizedBox(height: 66),
          ],
        ),
      ),
    );
  }
}
