import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lofo/theme/light_theme.dart';

// String requestUploadStatus = 'Normal';
ValueNotifier<String> requestUploadStatus = ValueNotifier<String>('Normal');
String userImagePath = 'assets/images/profileD.jpg';
Image userImageExample = Image.asset(userImagePath);

PreferredSize appBar(String title, Image? actionImage, {Widget? leading}) {
  // AppBar currentAppBar = normalAppBar(title, actionImage);
  // switch (requestUploadStatus) {
  //   case 'Normal':
  //     currentAppBar = normalAppBar(title, actionImage);
  //   case 'Uploading':
  //     currentAppBar = uploadingAppBar();
  //   case 'Uploaded':
  //     currentAppBar = uploadedAppBar();
  //   default:
  //     currentAppBar = normalAppBar(title, actionImage);
  // }

  return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: ValueListenableBuilder<String>(
        valueListenable: requestUploadStatus,
        builder: (context, value, child) {
          AppBar currentAppBar =
              normalAppBar(title, actionImage, leading: leading);
          switch (value) {
            case 'Normal':
              currentAppBar =
                  normalAppBar(title, actionImage, leading: leading);
              break;
            case 'Uploading':
              currentAppBar = uploadingAppBar();
              break;
            case 'Uploaded':
              currentAppBar = uploadedAppBar();
              break;
            default:
              currentAppBar =
                  normalAppBar(title, actionImage, leading: leading);
          }
          return AnimatedSwitcher(
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            duration: const Duration(milliseconds: 200),
            child: currentAppBar,
          );
        },
      ));
}

// PreferredSize appBar(String title, Image? actionImage) {
//   AppBar currentAppBar = normalAppBar(title, actionImage);
//   switch (requestUploadStatus) {
//     case 'Normal':
//       currentAppBar = normalAppBar(title, actionImage);
//     case 'Uploading':
//       currentAppBar = uploadingAppBar();
//     case 'Uploaded':
//       currentAppBar = uploadedAppBar();
//     default:
//       currentAppBar = normalAppBar(title, actionImage);
//   }

//   return PreferredSize(
//       preferredSize: const Size.fromHeight(56),
//       child: AnimatedSwitcher(
//         transitionBuilder: (child, animation) => FadeTransition(
//           opacity: animation,
//           child: child,
//         ),
//         duration: const Duration(milliseconds: 200),
//         child: currentAppBar,
//       ));
// }

AppBar uploadedAppBar() {
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

AppBar uploadingAppBar() {
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

AppBar normalAppBar(String title, Image? actionImage, {Widget? leading}) {
  return AppBar(
    key: ValueKey(title),
    centerTitle: false,
    title: Text(
      title,
      style: const TextStyle(fontVariations: [FontVariation('wght', 600)]),
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
