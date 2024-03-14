import 'package:flutter/material.dart';
import 'package:lofo/animation/login_intermediate.dart';
import 'package:lofo/backend/google_sign_in.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_pages/security_layout.dart';
import 'package:lofo/theme/light_theme.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class LoginDetails {
//   String loginID;
//   Image loginProfileImage;

//   LoginDetails({required this.loginID, required this.loginProfileImage});
// }

String? loginID = '';
Image? loginProfileImage;
String loginProfileImageURL = '';
String? userName = 'Darryl';

bool checkLoginDetails() {
  if (loginID!.endsWith('@iiti.ac.in')) {
    return true;
  } else {
    return false;
  }
}

Future<void> saveLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', isUserLoggedIn);
  prefs.setString('savedLoginID', loginID!);
  prefs.setString('savedUserName', userName!);
  prefs.setString('savedProfileImageURL', loginProfileImageURL);
}

Future<void> getLoginDetails() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  loginID = prefs.getString('savedLoginID') ?? '';
  userName = prefs.getString('savedUserName') ?? '';
  loginProfileImageURL = prefs.getString('savedProfileImageURL') ?? '';
  try {
    loginProfileImage = Image.network(loginProfileImageURL);
  } catch (e) {
    debugPrint('Error: $e');
  }
}

void performLogin(BuildContext context) async {
  await signUpWithGoogle(context);
  bool isLoginValid = checkLoginDetails();
  if (isLoginValid) {
    isUserLoggedIn = true;
    // loginProfileImage = Image.asset('assets/images/profileD.jpg');
    try {
      loginProfileImage = Image.network(loginProfileImageURL);
    } catch (e) {
      debugPrint('Error: $e');
    }

    saveLoginDetails();

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
    await signOut(context);
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

performLogout(BuildContext context) async {
  await signOut(context);

  loginID = '';
  userName = '';
  loginProfileImageURL = '';
  loginProfileImage = null;
  isUserLoggedIn = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isUserLoggedIn', false);
  prefs.setString('savedLoginID', '');
  prefs.setString('savedUserName', '');
  prefs.setString('savedProfileImageURL', '');

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

Future<void> navigateToAppropriatePostLoginPage(BuildContext context) async {
  if (isUserLoggedIn) {
    await checkLoginStatus(context);
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
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const LoginPage();
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

class LoginImageButton extends StatelessWidget {
  const LoginImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isUserLoggedIn)
          ? () {
              showPopover(
                  context: context,
                  shadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                  barrierColor: Colors.blueGrey[200]!.withOpacity(0.2),
                  transition: PopoverTransition.other,
                  radius: 13,
                  arrowWidth: 18,
                  arrowHeight: 10,
                  bodyBuilder: (context) {
                    return Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            popOverText(
                                'Logged In', Colors.green[800], 20, 700),
                            const SizedBox(height: 10),
                            popOverText(
                                'Name: $userName', Colors.black, 16, 600),
                            popOverText(
                                'Email: $loginID', Colors.black, 16, 600),
                          ],
                        ));
                  });
            }
          : null,
      child: loginProfileImage,
    );
  }

  Text popOverText(String text, Color? color, double? fontSize, double wght) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: fonts[0],
          fontVariations: [FontVariation('wght', wght)]),
    );
  }
}
