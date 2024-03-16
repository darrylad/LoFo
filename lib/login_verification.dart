import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/main.dart';
import 'package:lofo/pages/login_page.dart';

bool isUserLoggedIn = false;
bool loggedInAsSecurity = false;
String securityAccountEmail = 'securityoffice@iiti.ac.in';
// String securityAccountEmail = 'me220003079@iiti.ac.in';
// String securityAccountEmail = 'me220003022@iiti.ac.in';

class LoginVerification extends StatefulWidget {
  const LoginVerification({super.key});

  @override
  State<LoginVerification> createState() => _LoginVerificationState();
}

class _LoginVerificationState extends State<LoginVerification> {
  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      Key appKey = const Key('appValidity001');
      // String appKey = 'appValidity001';

      final remoteConfig = FirebaseRemoteConfig.instance;

      remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1)));

      remoteConfig.fetchAndActivate().then((_) {
        // Key receivedKey = Key(remoteConfig.getString('app_key'));

        Key receivedKey = Key(remoteConfig.getString('app_key'));

        if (receivedKey == appKey) {
          getLoginDetails().then((value) {
            navigateToAppropriatePostVerificationPage(context, this);
          });
        } else {
          if (!mounted) return;

          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const AppNotValidPage();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ));
        }
      });
    } catch (e) {
      debugPrint("$e");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    // colorScheme = themeData.colorScheme;

    return const Center(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              // SizedBox(height: 20),
              // Text('Verifying your login details...'),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> verifyAppValidity() async {
  Key appKey = const Key('appValidity001');

  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();
    Key receivedKey = Key(remoteConfig.getString('app_key'));
    debugPrint('Received Key: $receivedKey');

    if (receivedKey == appKey) {
      return true;
    } else {
      requestUploadStatus.value = RequestUploadStatus.someThingWentWrong;
      return false;
    }
  } catch (e) {
    debugPrint("$e");
    return false;
  }
}
