import 'package:flutter/material.dart';
import 'package:lofo/onboarding/Page3_archive.dart';
import 'package:lofo/onboarding/on_boarding_button.dart';
import 'package:lofo/theme/dark_theme.dart';

class Page2CreatePosts extends StatefulWidget {
  const Page2CreatePosts({super.key});

  @override
  State<Page2CreatePosts> createState() => _Page2CreatePostsState();
}

class _Page2CreatePostsState extends State<Page2CreatePosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 98, 161),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('assets/onboarding/page2create.png'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Send requests privately to the security',
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
                OnBoardingButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              // return const LoginPage();
                              return const Page3Archive();
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
                    buttonText: "Next"),
                const SizedBox(height: 50),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
