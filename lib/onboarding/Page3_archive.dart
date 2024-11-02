import 'package:flutter/material.dart';
import 'package:lofo/onboarding/Page4_notifications.dart';
import 'package:lofo/onboarding/on_boarding_button.dart';
import 'package:lofo/theme/dark_theme.dart';

class Page3Archive extends StatefulWidget {
  const Page3Archive({super.key});

  @override
  State<Page3Archive> createState() => _Page3ArchiveState();
}

class _Page3ArchiveState extends State<Page3Archive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 193, 107, 66),
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
                    Image.asset('assets/onboarding/Page3archive.png'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.archive_outlined,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    "Archive posts when you're done with them",
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
                  "The security will be signaled to delete them permanently",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                OnBoardingButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              // return const LoginPage();
                              return const Page4Notifications();
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
