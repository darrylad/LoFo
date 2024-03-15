import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/theme/light_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return Hero(
      tag: 'about',
      child: Scaffold(
          appBar: appBar('About', null, leading: leading),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  aboutText(
                      'Welcome to the Lofo app, a dedicated platform designed to simplify the lost and found process on campus. Our app provides students with a convenient way to report lost items, including descriptions and photos, which are then routed to campus security for assistance.'),
                  const SizedBox(height: 20),
                  aboutText(
                      'Made by Darryl David, Shivam Sharma, and Lovely Bhardwaj'),
                  const SizedBox(height: 20),
                  Opacity(
                      opacity: 0.5,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/gdsclogo.png',
                          width: 120,
                          fit: BoxFit.scaleDown,
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  Text aboutText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: fonts[1],
          fontSize: 16,
          color: primaryTextColor,
          fontVariations: const [FontVariation('wght', 400)]),
    );
  }
}
