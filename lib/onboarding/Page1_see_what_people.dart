import 'package:flutter/material.dart';
import 'package:lofo/onboarding/Page2_create_posts.dart';
import 'package:lofo/onboarding/on_boarding_button.dart';
import 'package:lofo/theme/default_theme.dart';

class PostsIntro extends StatelessWidget {
  const PostsIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 130, 83),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assets/onboarding/posts.png'),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'See what people have lost or found',
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
                              return const Page2CreatePosts();
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
