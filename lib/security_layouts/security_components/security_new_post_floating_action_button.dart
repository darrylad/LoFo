import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lofo/components/pulsing_child.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/security_layouts/security_pages/security_new_post_page.dart';

class SecurityNewPostFloatingActionButton extends StatefulWidget {
  // Define a GlobalKey
  final GlobalKey fabKey;

  // NewPostFloatingActionButton({
  //   super.key,
  // });

  const SecurityNewPostFloatingActionButton({required this.fabKey, Key? key})
      : super(key: key);

  @override
  State<SecurityNewPostFloatingActionButton> createState() =>
      _SecurityNewPostFloatingActionButtonState();
}

bool isNewSecurityPostAddable = securityRequestUploadStatus.value ==
        SecurityRequestUploadStatus.normal ||
    securityRequestUploadStatus.value == SecurityRequestUploadStatus.uploaded;

class _SecurityNewPostFloatingActionButtonState
    extends State<SecurityNewPostFloatingActionButton> {
  bool _isPressed = false;
  final ValueNotifier<Color> colorNotifier =
      ValueNotifier<Color>(securityColorScheme.primary);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SecurityRequestUploadStatus>(
      valueListenable: securityRequestUploadStatus,
      builder: (context, value, child) {
        isNewSecurityPostAddable =
            value == SecurityRequestUploadStatus.normal ||
                value == SecurityRequestUploadStatus.uploaded;
        colorNotifier.value = (isNewSecurityPostAddable)
            ? secondaryButtonBackgroundSolidColor
            : securityColorScheme.outlineVariant;

        return AnimatedBuilder(
          animation: colorNotifier,
          builder: (context, child) {
            return Hero(
              tag: 'postButton',
              child: GestureDetector(
                key: widget.fabKey,
                onTapDown: (details) {
                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (details) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      _isPressed = false;
                    });
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _isPressed = false;
                  });
                },
                onTap: (value == SecurityRequestUploadStatus.normal)
                    ? () {
                        // Get the position of the FAB

                        // final RenderBox? renderBox = fabKey.currentContext!
                        //     .findRenderObject() as RenderBox?;
                        // final Offset? position =
                        //     renderBox?.localToGlobal(Offset.zero);

                        final RenderBox? renderBox =
                            widget.fabKey.currentContext!.findRenderObject()
                                as RenderBox?;
                        final Offset? position = renderBox
                            ?.localToGlobal(renderBox.size.center(Offset.zero));

                        // Calculate the distance to the farthest corner
                        final distance = position != null
                            ? sqrt(pow(position.dx, 2) + pow(position.dy, 2))
                            : 0;
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return const SecurityNewPostPage();
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 550),
                                reverseTransitionDuration:
                                    const Duration(milliseconds: 600),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  final curvedAnimation = CurvedAnimation(
                                    parent: animation,
                                    curve: const Cubic(0.79, 0.01, 0.29, 1.09),
                                  );

                                  return Stack(children: [
                                    // Overlay a semi-transparent black layer that fades in as the animation progresses
                                    AnimatedBuilder(
                                      animation: curvedAnimation,
                                      builder: (context, child) {
                                        return BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX:
                                                  15 * curvedAnimation.value,
                                              sigmaY:
                                                  15 * curvedAnimation.value),
                                          child: Container(
                                            color: backgroundAnimationColor
                                                .withOpacity(0.7 *
                                                    curvedAnimation.value),
                                          ),
                                        );
                                      },
                                    ),
                                    AnimatedBuilder(
                                        animation: curvedAnimation,
                                        builder: (context, child) {
                                          return ClipPath(
                                            clipper: CircleClipper(
                                                curvedAnimation.value
                                                    .toDouble(),
                                                position!,
                                                distance.toDouble()),
                                            child: child,
                                          );
                                        },
                                        child: child),
                                  ]);
                                },
                              ));
                        });
                      }
                    : () {
                        // requestUploadStatus.value = 'Normal';
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _isPressed ? Colors.grey[400] : colorNotifier.value,
                    borderRadius: BorderRadius.circular(_isPressed ? 15 : 50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isPressed ? 0.3 : 0.2),
                        spreadRadius: _isPressed ? 2 : 1,
                        blurRadius: _isPressed ? 10 : 7,
                        offset: Offset(0,
                            _isPressed ? 5 : 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: (isNewSecurityPostAddable)
                      ? Icon(
                          Icons.add,
                          color: (isNewSecurityPostAddable)
                              ? (_isPressed)
                                  ? securityColorScheme.secondary
                                  : securityColorScheme.primary
                              : securityColorScheme.outline,
                        )
                      : PulsingChild(
                          child: Icon(
                          Icons.circle_outlined,
                          color: securityColorScheme.outline,
                        )),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final double radius;
  final Offset position;
  final double distance;

  CircleClipper(this.radius, this.position, this.distance);

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(center: position, radius: radius * distance));
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) {
    return radius != oldClipper.radius || position != oldClipper.position;
  }
}


// class NewPostFloatingActionButton extends StatelessWidget {
//   NewPostFloatingActionButton({
//     super.key,
//   });

//   final ValueNotifier<Color> colorNotifier =
//       ValueNotifier<Color>(colorScheme.primary);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<String>(
//       valueListenable: requestUploadStatus,
//       builder: (context, value, child) {
//         colorNotifier.value =
//             (value == 'Normal') ? colorScheme.primary : colorScheme.error;
//         return AnimatedBuilder(
//           animation: colorNotifier,
//           builder: (context, child) {
//             return Material(
//               color: Colors.transparent,
//               shape: const CircleBorder(),
//               elevation: 10,
//               child: InkWell(
//                 customBorder: const CircleBorder(),
//                 onTap: (value == 'Normal')
//                     ? () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (BuildContext context) {
//                           return const NewPostPage();
//                         }));
//                       }
//                     : () {
//                         requestUploadStatus.value = 'Normal';
//                       },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   decoration: BoxDecoration(
//                       color: colorNotifier.value, shape: BoxShape.circle),
//                   padding: const EdgeInsets.all(16),
//                   child: Icon(
//                     (value == 'Normal') ? Icons.add : Icons.close,
//                     color: (value == 'Normal')
//                         ? colorScheme.onPrimary
//                         : colorScheme.onError,
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }



// class NewPostFloatingActionButton extends StatelessWidget {
//   const NewPostFloatingActionButton({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<String>(
//       valueListenable: requestUploadStatus,
//       builder: (context, value, child) {
//         return FloatingActionButton(
//           backgroundColor:
//               (value == 'Normal') ? colorScheme.primary : colorScheme.error,
//           foregroundColor:
//               (value == 'Normal') ? colorScheme.onPrimary : colorScheme.onError,
//           shape: const CircleBorder(),
//           onPressed: (value == 'Normal')
//               ? () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                     return const NewPostPage();
//                   }));
//                 }
//               : () {
//                   requestUploadStatus.value = 'Normal';
//                 },
//           child: (value == 'Normal')
//               ? const Icon(Icons.add)
//               : const Icon(Icons.close),
//         );
//       },
//     );
//   }
// }
