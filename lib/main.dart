import 'package:flutter/material.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/theme/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  // getLoginDetails();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      // home: isUserLoggedIn ? const Layout() : const LoginPage(),
      home: const LoginVerification(),
    );
  }
}
