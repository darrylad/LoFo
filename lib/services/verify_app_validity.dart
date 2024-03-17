import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';

Future<bool> verifyAppValidity() async {
  Key appKey = const Key('appValidity001');

  try {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.fetchAndActivate();
    Key receivedKey = Key(remoteConfig.getString('app_key'));
    debugPrint('Received Key: $receivedKey');

    if (receivedKey == appKey) {
      return true;
    } else {
      requestUploadStatus.value = RequestUploadStatus.someThingWentWrong;
      return false;
    }
  } catch (e) {
    debugPrint("$e");
    return false;
  }
}
