import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';

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
          appBar: appBar('', null, leading: leading),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'About',
                    style: TextStyle(
                        fontFamily: fonts[0],
                        fontSize: 50,
                        color: themeData.colorScheme.onSurfaceVariant,
                        fontVariations: const [FontVariation('wght', 500)]),
                  ),
                  const SizedBox(height: 60),
                  aboutText(
                      'Welcome to the Lofo app, a dedicated platform designed to simplify the lost and found process on campus. Our app provides students with a convenient way to report lost items, including descriptions and photos, which are then routed to campus security for assistance.',
                      TextAlign.start),
                  const SizedBox(height: 20),
                  aboutText(
                      'Group: Darryl David, Shivam Sharma, and Lovely Bhardwaj',
                      TextAlign.left),
                  const SizedBox(height: 20),
                  aboutText('Darryl: Frontend and Backend', TextAlign.left),
                  aboutText('Shivam: AI', TextAlign.left),
                  aboutText('Lovely: AI', TextAlign.left),
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

  Text aboutText(String text, TextAlign textAlign) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: fonts[1],
          fontSize: 16,
          color: themeData.colorScheme.onSurfaceVariant,
          fontVariations: const [FontVariation('wght', 400)]),
    );
  }
}
