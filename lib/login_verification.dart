import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';

bool isUserLoggedIn = false;
// String securityAccountEmail = 'securityoffice@iiti.ac.in';
// String securityAccountEmail = 'me220003079@iiti.ac.in';
String securityAccountEmail = 'me220003022@iiti.ac.in';

class LoginVerification extends StatefulWidget {
  const LoginVerification({super.key});

  @override
  State<LoginVerification> createState() => _LoginVerificationState();
}

class _LoginVerificationState extends State<LoginVerification> {
  @override
  initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getLoginDetails().then((value) {
      navigateToAppropriatePostLoginPage(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
