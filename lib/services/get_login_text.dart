import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

Future<List<String?>?> getLoginText() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();

    String loginInformatoryText =
        remoteConfig.getString('login_informatory_text').replaceAll('\n', '\n');
    String loginButtonText = remoteConfig.getString('login_button_text');

    return [loginInformatoryText, loginButtonText];
  } catch (e) {
    debugPrint("$e");
    return null;
  }
}
