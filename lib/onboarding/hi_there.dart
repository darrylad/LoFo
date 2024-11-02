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
            Text("Hi there!",
                style: themeData.textTheme.titleMedium
                    ?.copyWith(color: themeData.colorScheme.onSurface)),
            const SizedBox(height: 300),
            Text(
              "Lets take a quick tour",
              style: themeData.textTheme.bodyLarge,
            ),
            const SizedBox(height: 60),
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
          ],
        ),
      ),
    );
  }
}
