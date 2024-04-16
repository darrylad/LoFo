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

// getAboutText() async {
//   try {
//     final remoteConfig = FirebaseRemoteConfig.instance;

//     await remoteConfig.fetchAndActivate();

//     String aboutText =
//         remoteConfig.getString('about_text').replaceAll('new_line', '\n');

//     return aboutText;
//   } catch (e) {
//     debugPrint("$e");
//     return 'Welcome to the Lofo app, a dedicated platform designed to simplify the lost and found process on campus. Our app provides students with a convenient way to report lost items, including descriptions and photos, which are then routed to campus security for assistance. \n \n \nGroup: Darryl David, Shivam Sharma, and Lovely Bhardwaj \n \n \n Darryl: Frontend and Backend \n Shivam: AI \n Lovely: AI \n \n \n';
//   }
// }
