import 'package:flutter/material.dart';
import 'package:lofo/theme/default_theme.dart';

enum RequestUploadStatus {
  normal,
  uploading,
  uploaded,
  uploadError,
  someThingWentWrong,
  deleting,
  deleted,
  deleteError,
  validating,
  archiving,
  archived,
  archiveError,
  unArchiving,
  unArchived,
  unArchiveError,
}

ValueNotifier<RequestUploadStatus> requestUploadStatus =
    ValueNotifier<RequestUploadStatus>(RequestUploadStatus.normal);
String userImagePath = 'assets/images/profileD.jpg';
Image userImageExample = Image.asset(userImagePath);

PreferredSize appBar(String title, Widget? actionImage, {Widget? leading}) {
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
      child: ValueListenableBuilder<RequestUploadStatus>(
        valueListenable: requestUploadStatus,
        builder: (context, value, child) {
          AppBar currentAppBar =
              normalAppBar(title, actionImage, leading: leading);
          switch (value) {
            case RequestUploadStatus.normal:
              currentAppBar =
                  normalAppBar(title, actionImage, leading: leading); // title
              break;
            case RequestUploadStatus.uploading:
              currentAppBar = uploadingAppBar(); // 4
              break;
            case RequestUploadStatus.uploaded:
              currentAppBar = uploadedAppBar(); // 0
              break;
            case RequestUploadStatus.uploadError:
              currentAppBar = uploadErrorAppBar(); // 5
              break;
            case RequestUploadStatus.someThingWentWrong:
              currentAppBar = someThingWentWrongAppBar(); // 6
              break;
            case RequestUploadStatus.deleting:
              currentAppBar = deletingAppBar(); // 2
              break;
            case RequestUploadStatus.deleted:
              currentAppBar = deletedAppBar(); // 1
              break;
            case RequestUploadStatus.deleteError:
              currentAppBar = deleteErrorAppBar(); // 3
              break;
            case RequestUploadStatus.validating:
              currentAppBar = validatingAppBar(); // 7
              break;
            case RequestUploadStatus.archiving:
              currentAppBar = archivingAppBar(); // 8
              break;
            case RequestUploadStatus.archived:
              currentAppBar = archivedAppBar(); // 9
              break;
            case RequestUploadStatus.archiveError:
              currentAppBar = archiveErrorAppBar(); // 10
              break;
            case RequestUploadStatus.unArchiving:
              currentAppBar = unArchivingAppBar(); // 11
              break;
            case RequestUploadStatus.unArchived:
              currentAppBar = unArchivedAppBar(); // 12
              break;
            case RequestUploadStatus.unArchiveError:
              currentAppBar = unArchiveErrorAppBar(); // 13
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
    key: const ValueKey(0),
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

AppBar deletedAppBar() {
  return AppBar(
    key: const ValueKey(1),
    centerTitle: true,
    title: const Text(
      'Deleted',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
  );
}

AppBar deletingAppBar() {
  return AppBar(
    key: const ValueKey(2),
    centerTitle: true,
    title: Text(
      'Deleting',
      style: TextStyle(
          color: ColorScheme.fromSeed(seedColor: Colors.amber).onPrimary,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.amber).primary,
  );
}

AppBar deleteErrorAppBar() {
  return AppBar(
    key: const ValueKey(3),
    centerTitle: true,
    title: Text(
      'Could not delete',
      style: TextStyle(
          color: lightThemeData.colorScheme.onError,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar uploadingAppBar() {
  return AppBar(
    key: const ValueKey(4),
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

AppBar uploadErrorAppBar() {
  return AppBar(
    key: const ValueKey(5),
    centerTitle: true,
    title: const Text(
      'Could not send',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar someThingWentWrongAppBar() {
  return AppBar(
    key: const ValueKey(6),
    centerTitle: true,
    title: const PulsingText(
      text: 'Something went wrong',
      style: TextStyle(fontVariations: [FontVariation('wght', 600)]),
    ),
    // backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar validatingAppBar() {
  return AppBar(
    key: const ValueKey(7),
    centerTitle: true,
    title: const PulsingText(
      text: 'Validating',
      style: TextStyle(fontVariations: [FontVariation('wght', 600)]),
    ),
    // backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar normalAppBar(String title, Widget? actionImage, {Widget? leading}) {
  return AppBar(
    key: ValueKey(title),
    centerTitle: false,
    title: Text(
      title,
      style: const TextStyle(fontVariations: [FontVariation('wght', 600)]),
      overflow: TextOverflow.ellipsis,
    ),
    leading: leading,
    actions: [
      // (actionImage != null)
      //     ? IconButton(
      //         onPressed: null,
      //         icon: Container(
      //           decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               border: Border.all(color: Colors.white, width: 2)),
      //           child: ClipOval(
      //             child: actionImage,
      //           ),
      //         ),
      //       )
      //     : const SizedBox(),
      (actionImage != null)
          ? Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: ClipOval(
                child: actionImage,
              ),
            )
          : const SizedBox(),
      const SizedBox(width: 12)
    ],
  );
}

AppBar archivingAppBar() {
  return AppBar(
    key: const ValueKey(8),
    centerTitle: true,
    title: Text(
      'Archiving',
      style: TextStyle(
          color: ColorScheme.fromSeed(seedColor: Colors.amber[900]!).onPrimary,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor:
        ColorScheme.fromSeed(seedColor: Colors.amber[900]!).primary,
  );
}

AppBar archivedAppBar() {
  return AppBar(
    key: const ValueKey(9),
    centerTitle: true,
    title: const Text(
      'Archived',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
  );
}

AppBar archiveErrorAppBar() {
  return AppBar(
    key: const ValueKey(10),
    centerTitle: true,
    title: Text(
      'Could not archive',
      style: TextStyle(
          color: lightThemeData.colorScheme.onError,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar unArchivingAppBar() {
  return AppBar(
    key: const ValueKey(11),
    centerTitle: true,
    title: Text(
      'Unarchiving',
      style: TextStyle(
          color: ColorScheme.fromSeed(seedColor: Colors.amber[900]!).onPrimary,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor:
        ColorScheme.fromSeed(seedColor: Colors.amber[900]!).primary,
  );
}

AppBar unArchivedAppBar() {
  return AppBar(
    key: const ValueKey(12),
    centerTitle: true,
    title: const Text(
      'Unarchived',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
  );
}

AppBar unArchiveErrorAppBar() {
  return AppBar(
    key: const ValueKey(13),
    centerTitle: true,
    title: Text(
      'Could not unarchive',
      style: TextStyle(
          color: lightThemeData.colorScheme.onError,
          fontVariations: const [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.error,
  );
}

class PulsingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const PulsingText({super.key, required this.text, required this.style});

  @override
  PulsingTextState createState() => PulsingTextState();
}

class PulsingTextState extends State<PulsingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _animation.value,
          child: Text(widget.text, style: widget.style),
        );
      },
    );
  }
}
