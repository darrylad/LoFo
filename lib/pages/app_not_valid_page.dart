import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/main.dart';
import 'package:url_launcher/url_launcher.dart';

String? updateURL;

class AppNotValidPage extends StatefulWidget {
  const AppNotValidPage({super.key});

  @override
  State<AppNotValidPage> createState() => _AppNotValidPageState();
}

class _AppNotValidPageState extends State<AppNotValidPage> {
  @override
  void initState() {
    super.initState();
    performLogout();
    // Future.delayed(const Duration(seconds: 5), () {
    //   SystemNavigator.pop();
    // });
  }

  final Uri _url = Uri.parse(updateURL ?? 'https://github.com/darrylad/LoFo');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchUrl();
      },
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 50),
            Icon(Icons.info_rounded,
                size: 150, color: themeData.colorScheme.secondary),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text('Please update the app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeData.colorScheme.secondary,
                    fontSize: 20,
                  )),
            ),
            const SizedBox(height: 50),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: themeData.colorScheme.tertiary,
              ),
              child: Center(
                child: Text('Update',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeData.colorScheme.secondary,
                      fontSize: 20,
                    )),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class SomeThingWentWrongPage extends StatelessWidget {
  const SomeThingWentWrongPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.signal_wifi_connected_no_internet_4_rounded,
              size: 150, color: themeData.colorScheme.secondary),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Text('Unable to verify the app. Please check your network.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeData.colorScheme.secondary,
                  fontSize: 20,
                )),
          ),
        ],
      ),
    ));
  }
}
