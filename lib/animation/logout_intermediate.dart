import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:lofo/theme/default_theme.dart';

class LogoutIntermediatePage extends StatefulWidget {
  const LogoutIntermediatePage({super.key});

  @override
  State<LogoutIntermediatePage> createState() => _LogoutIntermediatePageState();
}

class _LogoutIntermediatePageState extends State<LogoutIntermediatePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _nonBouncyAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    const curve = Cubic(0.7, 0, 0.04, 1.0); // Customize this to your needs
    _animation = CurvedAnimation(parent: _animationController, curve: curve)
      ..addListener(() {
        setState(() {});
      });

    const nonBouncyCurve = Cubic(0.51, 0, 0.01, 1);
    _nonBouncyAnimation =
        CurvedAnimation(parent: _animationController, curve: nonBouncyCurve)
          ..addListener(() {
            setState(() {});
          });

    _animationController.forward().then((value) {
      Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
        return const LoginPage();
      }));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topPaddingHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: [
        layoutWidget,
        AnimatedBuilder(
          animation: _nonBouncyAnimation,
          builder: (BuildContext context, Widget? child) {
            return BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10 * _nonBouncyAnimation.value,
                sigmaY: 10 * _nonBouncyAnimation.value,
              ),
              child: Container(
                color: backgroundAnimationColor
                    .withOpacity(0.5 * _nonBouncyAnimation.value),
              ),
            );
          },
        ),
        Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Transform.translate(
                  offset: Offset(
                    0,
                    (1 - _animation.value) *
                        (-screenHeight + topPaddingHeight + 56),
                  ),
                  child: Stack(children: [
                    const LoginPage(),
                    Opacity(
                      opacity: (1 - _nonBouncyAnimation.value),
                      child: Column(
                        children: [
                          const Spacer(),
                          currentAppBar,
                        ],
                      ),
                    )
                  ]));
            },
          ),
        ),
      ],
    );
  }
}
