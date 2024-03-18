import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/theme/default_theme.dart';

enum SecurityRequestUploadStatus {
  normal,
  uploading,
  uploaded,
  uploadError,
  someThingWentWrong,
  deleting,
  deleted,
  deleteError,
  publicizing,
  publicized,
  publicizeError,
  validating
}

// String requestUploadStatus = 'Normal';
ValueNotifier<SecurityRequestUploadStatus> securityRequestUploadStatus =
    ValueNotifier<SecurityRequestUploadStatus>(
        SecurityRequestUploadStatus.normal);
String userImagePath = 'assets/images/profileD.jpg';
Image securityImageExample = Image.asset(userImagePath);

PreferredSize securityAppBar(String title, Widget? actionImage,
    {Widget? leading}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: ValueListenableBuilder<SecurityRequestUploadStatus>(
        valueListenable: securityRequestUploadStatus,
        builder: (context, value, child) {
          AppBar currentSecurityAppBar =
              normalSecurityAppBar(title, actionImage, leading: leading);
          switch (value) {
            case SecurityRequestUploadStatus.normal:
              currentSecurityAppBar =
                  normalSecurityAppBar(title, actionImage, leading: leading);
              break;
            case SecurityRequestUploadStatus.uploading:
              currentSecurityAppBar = uploadingSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.uploaded:
              currentSecurityAppBar = uploadedSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.uploadError:
              currentSecurityAppBar = uploadErrorSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.someThingWentWrong:
              currentSecurityAppBar = someThingWentWrongSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.deleteError:
              currentSecurityAppBar = deleteErrorSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.deleted:
              currentSecurityAppBar = deletedSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.deleting:
              currentSecurityAppBar = deletingSecurityAppBar();
            case SecurityRequestUploadStatus.publicizing:
              currentSecurityAppBar = publicizingSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.publicized:
              currentSecurityAppBar = publicizedSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.publicizeError:
              currentSecurityAppBar = publicizeErrowSecurityAppBar();
              break;
            case SecurityRequestUploadStatus.validating:
              currentSecurityAppBar = validatingSecurityAppBar();
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

AppBar deletingSecurityAppBar() {
  return AppBar(
    key: const ValueKey(1),
    centerTitle: true,
    title: const Text(
      'Deleting',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor:
        ColorScheme.fromSeed(seedColor: Colors.amber[900]!).primary,
  );
}

AppBar deletedSecurityAppBar() {
  return AppBar(
    key: const ValueKey(2),
    centerTitle: true,
    title: const Text(
      'Deleted',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
  );
}

AppBar deleteErrorSecurityAppBar() {
  return AppBar(
    key: const ValueKey(3),
    centerTitle: true,
    title: const Text(
      'Could not delete',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: securityThemeData.colorScheme.onError,
  );
}

AppBar uploadedSecurityAppBar() {
  return AppBar(
    key: const ValueKey(4),
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

AppBar publicizingSecurityAppBar() {
  return AppBar(
    key: const ValueKey(5),
    centerTitle: true,
    title: const Text(
      'Publicizing copy',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.primary,
  );
}

AppBar uploadingSecurityAppBar() {
  return AppBar(
    key: const ValueKey(6),
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

AppBar uploadErrorSecurityAppBar() {
  return AppBar(
    key: const ValueKey(7),
    centerTitle: true,
    title: const Text(
      'Could not send',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar someThingWentWrongSecurityAppBar() {
  return AppBar(
    backgroundColor: securityColorScheme.background,
    key: const ValueKey(8),
    centerTitle: true,
    title: const PulsingText(
      text: 'Something went wrong',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    // backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar publicizedSecurityAppBar() {
  return AppBar(
    key: const ValueKey(9),
    centerTitle: true,
    title: const Text(
      'Publicized copy',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: ColorScheme.fromSeed(seedColor: Colors.green).primary,
  );
}

AppBar publicizeErrowSecurityAppBar() {
  return AppBar(
    key: const ValueKey(10),
    centerTitle: true,
    title: const Text(
      'Could not publicize',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    backgroundColor: securityThemeData.colorScheme.onError,
  );
}

AppBar validatingSecurityAppBar() {
  return AppBar(
    backgroundColor: securityColorScheme.background,
    key: const ValueKey(11),
    centerTitle: true,
    title: const PulsingText(
      text: 'Validating',
      style: TextStyle(
          color: Colors.white, fontVariations: [FontVariation('wght', 600)]),
    ),
    // backgroundColor: lightThemeData.colorScheme.error,
  );
}

AppBar normalSecurityAppBar(String title, Widget? actionImage,
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
