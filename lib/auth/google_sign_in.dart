import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';

signUpWithGoogle(BuildContext context, State state) async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (!state.mounted) return;

    showLoadingScreen(state.context);

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential authcredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // debugPrint('AuthCredential: $authcredential');
    // debugPrint('GoogleSignInAccount: $googleUser');

    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(authcredential);

    // debugPrint('User: $user');

    loginID = user.user?.email;
    // debugPrint('LoginID: $loginID');
    userName = user.user?.displayName;
    // debugPrint('UserName: $userName');
    loginProfileImageURL = user.user?.photoURL ?? '';
    // loginProfileImage = Image.network(user.user?.photoURL ?? '');

    if (!state.mounted) return;
    Navigator.pop(state.context);
  } catch (e) {
    debugPrint('Error: $e');
    Navigator.pop(state.context);
  }

  // user.user?.email;
}

signOut() async {
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
      barrierColor: themeData.scaffoldBackgroundColor.withOpacity(0.5),
      context: context,
      builder: ((context) {
        return Center(
            child: CircularProgressIndicator(
          color: themeData.colorScheme.onBackground,
        ));
      }));
}

// called when app is opened with a pre-existing login
checkLoginStatus(BuildContext context, State state) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    debugPrint('current User: $user');
    debugPrint('current User: ${user?.uid}');

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

        if (!state.mounted) return;
        await signOut();
        await saveLoginDetails();
      }
    } else {
      isUserLoggedIn = false;
      loginID = '';
      userName = '';
      loginProfileImageURL = '';

      await signOut();
      await saveLoginDetails();
    }
  } catch (e) {
    isUserLoggedIn = false;
    loginID = '';
    userName = '';
    loginProfileImageURL = '';
    debugPrint('Error: $e');

    if (!state.mounted) return;
    await signOut();
    // await saveLoginDetails();
    if (!state.mounted) return;
    await performLogout();
  }
}
