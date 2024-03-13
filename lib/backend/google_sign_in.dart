import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/login_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

signinwithgoogle(BuildContext context) async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  showLoadingScreen(context);

  try {
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential authcredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    debugPrint('AuthCredential: $authcredential');
    debugPrint('GoogleSignInAccount: $googleUser');

    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(authcredential);

    debugPrint('User: $user');

    loginID = user.user?.email;
    debugPrint('LoginID: $loginID');
    userName = user.user?.displayName;
    debugPrint('UserName: $userName');
    loginProfileImageURL = user.user?.photoURL ?? '';
    loginProfileImage = Image.network(user.user?.photoURL ?? '');
    Navigator.pop(context);
  } catch (e) {
    debugPrint('Error: $e');
    Navigator.pop(context);
  }

  // user.user?.email;
}

signOut(BuildContext context) async {
  try {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    debugPrint('User signed out');
  } catch (e) {
    debugPrint('Error: $e');
  }
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
}

void showLoadingScreen(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      }));
}
