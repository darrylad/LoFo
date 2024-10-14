import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lofo/animation/login_intermediate.dart';
import 'package:lofo/auth/google_sign_in.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/main.dart';
import 'package:lofo/pages/login_page.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/pages/more_page.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_pages/security_layout.dart';
import 'package:lofo/theme/default_theme.dart';
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
  if (loginID!.endsWith('@iiti.ac.in') ||
      loginID! == "darrylcad@gmail.com" ||
      specialAccounts.contains(loginID)) {
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
  forceLightTheme.value = prefs.getBool('forceLightTheme') ?? false;
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

void performLogin(BuildContext context, State state) async {
  await signUpWithGoogle(context, state);
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

    if (!state.mounted) return;

    setAppropriatePostLoginPage(state.context);

    Navigator.pushReplacement(state.context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return const LoginIntermediatePage();
    }));

    debugPrint('Login Successful');
  } else {
    if (!state.mounted) return;
    await signOut();
    debugPrint('Login Failed');
    if (!state.mounted) return;
    Navigator.pushReplacement(
      state.context,
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

performLogout() async {
  await signOut();

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

bool checkIfSecurityAccount() {
  if (loginID == securityAccountEmail) {
    return true;
  } else {
    return false;
  }
}

Future<bool> checkIfOneOfSecurityAccounts() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();
    String secAccountsJson = remoteConfig.getString("security_accounts");
    Map<String, dynamic> jsonMap = jsonDecode(secAccountsJson);
    List<String> secAccounts = List<String>.from(jsonMap['emails']);

    if (secAccounts.contains(loginID)) {
      return true;
    }
  } catch (e) {
    debugPrint('$e');
    return false;
  }
  return false;
}

Future<void> navigateToAppropriatePostVerificationPage(
    BuildContext context, State state) async {
  if (isUserLoggedIn) {
    await checkLoginStatus(state.context, state);

    if (!state.mounted) return;

    // if (loginID!.endsWith('@iiti.ac.in')) {
    if (checkLoginDetails()) {
      // check if log in account is security's account

      // if (checkIfSecurityAccount()) {
      if (await checkIfOneOfSecurityAccounts()) {
        loggedInAsSecurity = true;
        layoutWidget = const SecurityLayout();
        currentAppBar = securityAppBar('Home', securityImageExample);

        Navigator.pushReplacement(
            state.context,
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
      } else
      // log in account is user's account

      {
        layoutWidget = const Layout();
        currentAppBar = appBar('Home', userImageExample);
        Navigator.pushReplacement(
            state.context,
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
    } else
    // log in account is not from IITI

    {
      Navigator.pushReplacement(
          state.context,
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
  } else
  // user is not logged in

  {
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
    themeData = Theme.of(context);
    ColorScheme colorScheme = themeData.colorScheme;
    return GestureDetector(
      onTap: (isUserLoggedIn)
          ? () {
              showPopover(
                  context: context,
                  shadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                  backgroundColor: themeData.colorScheme.tertiary,
                  barrierColor:
                      themeData.scaffoldBackgroundColor.withOpacity(0.3),
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
                                'Logged In',
                                //  Colors.green[700],
                                ColorScheme.fromSeed(
                                        seedColor: Colors.green,
                                        brightness: themeData.brightness)
                                    .primary,
                                20,
                                700),
                            const SizedBox(height: 10),
                            popOverText('Name: $userName',
                                colorScheme.onSurface, 16, 600),
                            popOverText('Email: $loginID',
                                colorScheme.onSurface, 16, 600),
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
