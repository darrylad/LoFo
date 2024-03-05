import 'package:flutter/material.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:lofo/theme/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isUserLoggedIn = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
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
      home: isUserLoggedIn ? const Layout() : LoginPage(),
    );
  }
}
