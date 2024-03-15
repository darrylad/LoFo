import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/theme/light_theme.dart';

enum SecurityRequestUploadStatus {
  normal,
  uploading,
  uploaded,
  uploadError,
  someThingWentWrong,
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

AppBar uploadErrorSecurityAppBar() {
  return AppBar(
    key: const ValueKey(3),
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
    key: const ValueKey(4),
    centerTitle: true,
    title: const PulsingText(
      text: 'Something went wrong',
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
