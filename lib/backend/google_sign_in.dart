import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/login_verification.dart';

signUpWithGoogle(BuildContext context) async {
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
    // loginProfileImage = Image.network(user.user?.photoURL ?? '');
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
    // await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      debugPrint('Firebase.instance.currentUser?.delete()');
    } catch (e) {
      debugPrint('Firebase.instance.currentUser?.delete() Error: $e');
    }
    debugPrint('User signed out');
  } catch (e) {
    debugPrint('Error: $e');
  }
  loginID = '';
  userName = '';
  loginProfileImageURL = '';
  loginProfileImage = null;
  isUserLoggedIn = false;
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setBool('isUserLoggedIn', false);
  // prefs.setString('savedLoginID', '');
  // prefs.setString('savedUserName', '');
  // prefs.setString('savedProfileImageURL', '');
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

checkLoginStatus(BuildContext context) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    debugPrint('current User: $user');

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is signed in, navigate to the main screen

        loginID = user.email;
        userName = user.displayName;
        loginProfileImageURL = user.photoURL ?? '';
        debugPrint('user!=null, LoginID: $loginID');
        await saveLoginDetails();
      } else {
        // No user is signed in, navigate to the login screen
        isUserLoggedIn = false;
        loginID = '';
        userName = '';
        loginProfileImageURL = '';
        await signOut(context);
        await saveLoginDetails();
      }
    } else {
      isUserLoggedIn = false;
      loginID = '';
      userName = '';
      loginProfileImageURL = '';
      await signOut(context);
      await saveLoginDetails();
    }
  } catch (e) {
    isUserLoggedIn = false;
    loginID = '';
    userName = '';
    loginProfileImageURL = '';
    debugPrint('Error: $e');
    await signOut(context);
    // await saveLoginDetails();
    await performLogout(context);
  }
}
