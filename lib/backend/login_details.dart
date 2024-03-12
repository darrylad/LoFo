import 'package:flutter/material.dart';
import 'package:lofo/animation/login_intermediate.dart';
import 'package:lofo/backend/login_main.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_pages/security_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class LoginDetails {
//   String loginID;
//   Image loginProfileImage;

//   LoginDetails({required this.loginID, required this.loginProfileImage});
// }

String? loginID;
Image? loginProfileImage;
String? userName = 'Darryl';

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
  isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  loginID = prefs.getString('savedLoginID') ?? '';
}

void performLogin(BuildContext context) {
  // signinwithgoogle();
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

    // animationController.forward().then((value) {
    //   Navigator.pushReplacement(context, PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) {
    //     return const Layout();
    //   }));
    // });

    setAppropriatePostLoginPage(context);

    Navigator.pushReplacement(context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return const LoginIntermediatePage();
    }));

    debugPrint('Login Successful');
  } else {
    debugPrint('Login Failed');
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginFailedPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

void performLogout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', false);
  prefs.setString('savedLoginID', '');

  isUserLoggedIn = false;
  // Navigator.pushReplacement(context,
  //     MaterialPageRoute(builder: (BuildContext context) {
  //   return LoginPage();
  // }));
}

void setAppropriatePostLoginPage(BuildContext context) {
  if (isUserLoggedIn) {
    if (loginID!.endsWith('@iiti.ac.in')) {
      if (loginID == securityAccountEmail) {
        layoutWidget = const SecurityLayout();
        currentAppBar = securityAppBar('Home', securityImageExample);
      } else {
        layoutWidget = const Layout();
        currentAppBar = appBar('Home', userImageExample);
      }
    }
  }
}

void navigateToAppropriatePostLoginPage(BuildContext context) {
  if (isUserLoggedIn) {
    if (loginID!.endsWith('@iiti.ac.in')) {
      if (loginID == securityAccountEmail) {
        layoutWidget = const SecurityLayout();
        currentAppBar = securityAppBar('Home', securityImageExample);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const SecurityLayout();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ));
      } else {
        layoutWidget = const Layout();
        currentAppBar = appBar('Home', userImageExample);
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const Layout();
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
    }
  } else {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ));
  }
}
