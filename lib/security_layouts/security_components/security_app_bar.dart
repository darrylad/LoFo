import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/theme/light_theme.dart';

// String requestUploadStatus = 'Normal';
ValueNotifier<String> securityRequestUploadStatus =
    ValueNotifier<String>('Normal');
String userImagePath = 'assets/images/profileD.jpg';
Image securityImageExample = Image.asset(userImagePath);

PreferredSize securityAppBar(String title, Image? actionImage,
    {Widget? leading}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: ValueListenableBuilder<String>(
        valueListenable: securityRequestUploadStatus,
        builder: (context, value, child) {
          AppBar currentSecurityAppBar =
              normalSecurityAppBar(title, actionImage, leading: leading);
          switch (value) {
            case 'Normal':
              currentSecurityAppBar =
                  normalSecurityAppBar(title, actionImage, leading: leading);
              break;
            case 'Uploading':
              currentSecurityAppBar = uploadingSecurityAppBar();
              break;
            case 'Uploaded':
              currentSecurityAppBar = uploadedSecurityAppBar();
              break;
            default:
              currentSecurityAppBar =
                  normalSecurityAppBar(title, actionImage, leading: leading);
          }
          return AnimatedSwitcher(
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            duration: const Duration(milliseconds: 200),
            child: currentSecurityAppBar,
          );
        },
      ));
}

AppBar uploadedSecurityAppBar() {
  return AppBar(
    key: const ValueKey(2),
    centerTitle: true,
    title: const Text(
      'Sent',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
    // bottom: const PreferredSize(
    //   preferredSize: Size.fromHeight(4),
    //   child: LinearProgressIndicator(
    //     value: 0.5,
    //     backgroundColor: Colors.white,
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    //   ),
    // ),
  );
}

AppBar uploadingSecurityAppBar() {
  return AppBar(
    key: const ValueKey(1),
    centerTitle: true,
    title: const Text(
      'Sending',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.primary,
    // bottom: const PreferredSize(
    //   preferredSize: Size.fromHeight(4),
    //   child: LinearProgressIndicator(
    //     value: 0.5,
    //     backgroundColor: Colors.white,
    //     valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    //   ),
    // ),
  );
}

AppBar normalSecurityAppBar(String title, Image? actionImage,
    {Widget? leading}) {
  return AppBar(
    backgroundColor: securityColorScheme.background,
    key: ValueKey(title),
    centerTitle: false,
    title: Text(
      title,
      style: TextStyle(
          color: securityColorScheme.onBackground,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    leading: leading,
    actions: [
      (actionImage != null)
          ? IconButton(
              onPressed: null,
              icon: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2)),
                child: ClipOval(
                  child: actionImage,
                ),
              ),
            )
          : const SizedBox(),
      const SizedBox(width: 8)
    ],
  );
}
