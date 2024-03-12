import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

signinwithgoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
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

  user.user?.email;
}
