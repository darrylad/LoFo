import 'package:flutter/material.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/main.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class LoginDetails {
//   String loginID;
//   Image loginProfileImage;

//   LoginDetails({required this.loginID, required this.loginProfileImage});
// }

String? loginID;
Image? loginProfileImage;

bool checkLoginDetails() {
  if (loginID!.endsWith('@iiti.ac.in')) {
    return true;
  } else {
    return false;
  }
}

Future<void> saveLoginDetails(String id, Image profileImage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', true);
  prefs.setString('savedLoginID', loginID!);
}

Future<void> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loginID = prefs.getString('savedLoginID') ?? '';
}

void performLogin(BuildContext context, AnimationController _controller) {
  bool isLoginValid = checkLoginDetails();
  if (isLoginValid) {
    isUserLoggedIn = true;
    loginProfileImage = Image.asset('assets/images/profileD.jpg');

    saveLoginDetails(loginID!, loginProfileImage!);

    // unlock the app to user
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (BuildContext context) {
    //   return const Layout();
    // }));

    // Navigator.pushReplacement(
    //     context,
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           const Layout(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return AnimatedBuilder(
    //           animation: animation,
    //           builder: (context, child) {
    //             return Align(
    //               alignment: Alignment.topCenter,
    //               child: ClipRect(
    //                 child: Transform.scale(
    //                   scale: (1 - animation.value).clamp(0.0, 1.0),
    //                   child: Transform.translate(
    //                     offset: Offset(0.0, -animation.value * 300),
    //                     child: child,
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //           child: child,
    //         );
    //       },
    //     ));

    _controller.forward().then((value) {
      Navigator.pushReplacement(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
        return const Layout();
      }));
    });

    debugPrint('Login Successful');
  } else {
    debugPrint('Login Failed');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const LoginFailedPage();
    }));
  }
}

void performLogout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', false);
  prefs.setString('savedLoginID', '');

  isUserLoggedIn = false;
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return LoginPage();
  }));
}
