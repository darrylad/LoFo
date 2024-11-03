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
      backgroundColor: ColorScheme.fromSeed(seedColor: Colors.blueAccent)
          .surfaceContainerHigh,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Text("Hi there!",
                style: themeData.textTheme.titleMedium
                    ?.copyWith(color: const Color.fromARGB(255, 59, 119, 223))),
            Expanded(
                child: Center(
                    child: RippleEffect(
              size: 300,
              widsize: 200,
              color: Colors.white,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: themeData.colorScheme.primaryContainer,
                  image: const DecorationImage(
                    image: AssetImage("assets/icons/icon.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ))),
            Text(
              "Let's take a quick tour",
              style: themeData.textTheme.bodyLarge?.copyWith(
                color:
                    ColorScheme.fromSeed(seedColor: Colors.blueAccent).primary,
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

class RippleEffect extends StatefulWidget {
  final double size;
  final double widsize;
  final Widget child;
  final Color color;

  const RippleEffect({
    super.key,
    required this.size,
    required this.child,
    required this.widsize,
    required this.color,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Repeat the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ripple circle
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double startSize = widget.widsize;
            final double endSize = widget.size;
            final double size =
                startSize + (endSize - startSize) * _controller.value;

            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color.withOpacity(1 - _controller.value),
              ),
            );
          },
        ),
        // Main container
        widget.child,
      ],
    );
  }
}
