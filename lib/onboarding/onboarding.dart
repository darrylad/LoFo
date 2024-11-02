import 'package:flutter/material.dart';
import 'package:lofo/onboarding/hi_there.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: PageView(
    //     children: const [
    //       HiThere(),
    //     ],
    //   ),
    // );
    return const HiThere();
  }
}
