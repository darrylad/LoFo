import 'package:flutter/material.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/theme/dark_theme.dart';
import 'package:lofo/theme/default_theme.dart';
import 'dart:ui';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/pulsing_child.dart';

class TransparentRoute extends PageRoute<void> {
  final WidgetBuilder builder;

  TransparentRoute({required this.builder});

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class NPostFAB extends StatefulWidget {
  // Define a GlobalKey
  final GlobalKey fabKey;

  const NPostFAB({required this.fabKey, Key? key}) : super(key: key);

  @override
  State<NPostFAB> createState() => _NPostFABState();
}

bool isNewPostAddable =
    requestUploadStatus.value == RequestUploadStatus.normal ||
        requestUploadStatus.value == RequestUploadStatus.uploaded;

class _NPostFABState extends State<NPostFAB> {
  bool _isPressed = false;
  final ValueNotifier<Color> colorNotifier =
      ValueNotifier<Color>(lightColorScheme.primary);

  void _openFABOverlay(BuildContext context) {
    Navigator.of(context).push(
      TransparentRoute(
        builder: (context) => const FABOverlay(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<RequestUploadStatus>(
      valueListenable: requestUploadStatus,
      builder: (context, value, child) {
        isNewPostAddable = value == RequestUploadStatus.normal ||
            value == RequestUploadStatus.uploaded;
        colorNotifier.value = (isNewPostAddable)
            ? lightColorScheme.primary
            : lightColorScheme.outline;

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
                onTap: (value == RequestUploadStatus.normal)
                    ? () {
                        // Navigator.push(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder:
                        //         (context, animation, secondaryAnimation) {
                        //       return const FABOverlay();
                        //     },
                        //     transitionDuration: Duration.zero,
                        //     reverseTransitionDuration: Duration.zero,
                        //   ),
                        // );

                        _openFABOverlay(context);
                      }
                    : () {},
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
                        offset: Offset(0, _isPressed ? 5 : 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: (isNewPostAddable)
                      ? Icon(
                          Icons.add,
                          color: (isNewPostAddable)
                              ? (_isPressed)
                                  ? lightColorScheme.secondary
                                  : lightColorScheme.onPrimary
                              : lightColorScheme.onError,
                        )
                      : PulsingChild(
                          child: Icon(
                            Icons.circle_outlined,
                            color: lightColorScheme.onError,
                          ),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class FABOverlay extends StatefulWidget {
  const FABOverlay({super.key});

  @override
  State<FABOverlay> createState() => _FABOverlayState();
}

class _FABOverlayState extends State<FABOverlay> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  late Animation<Offset> _offsetAnimationLost;
  late Animation<Offset> _offsetAnimationFound;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Cubic(0.79, 0.01, 0.29, 1.09),
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation =
        Tween<double>(begin: 0, end: 0.7853981634).animate(_rotationController);

    _offsetAnimationLost = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 150),
    ).animate(_curvedAnimation);

    _offsetAnimationFound = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 250),
    ).animate(_curvedAnimation);

    _sizeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_curvedAnimation);

    _animationController.forward();

    _rotationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();

    super.dispose();
  }

  void _togglePressed() {
    setState(() {
      _isPressed = !_isPressed;
      if (_isPressed) {
        _rotationController.reverse();
      } else {
        _rotationController.forward();
      }
    });
  }

  Widget quickLinks(
      String label, Animation<Offset> offsetAnimation, Function() onPressed) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 74 + offsetAnimation.value.dy,
          right: 16 - (1 - _sizeAnimation.value) * 16,
          child: Align(
            alignment: Alignment.centerRight,
            child: Transform.scale(
              scale: _sizeAnimation.value,
              child: FadeTransition(
                opacity: _sizeAnimation,
                child: BasicButton.primaryButton(
                  label,
                  onPressed,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // layoutWidget,
          AnimatedBuilder(
            animation: _curvedAnimation,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 6 * _curvedAnimation.value,
                    sigmaY: 6 * _curvedAnimation.value),
                child: Container(
                  color: (Theme.of(context).brightness == Brightness.light
                          ? backgroundFABColor
                          : backgroundFABColorDark)
                      .withOpacity(0.7 * _curvedAnimation.value),
                ),
              );
            },
          ),
          quickLinks('I Found ... ', _offsetAnimationFound, () {}),
          quickLinks('I Lost ... ', _offsetAnimationLost, () {}),
          Positioned(
            bottom: 74,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _togglePressed();
                _animationController.reverse().then((_) {
                  Navigator.pop(context);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  color: _isPressed
                      ? lightColorScheme.primary
                      : const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(_isPressed ? 50 : 15),
                ),
                padding: const EdgeInsets.all(16),
                child: (isNewPostAddable)
                    ? AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) => Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Icon(
                            Icons.add,
                            color: _isPressed
                                ? lightColorScheme.onPrimary
                                : lightColorScheme.secondary,
                          ),
                        ),
                      )
                    : PulsingChild(
                        child: Icon(
                          // Icons.arrow_circle_up_rounded,
                          Icons.circle_outlined,
                          color: lightColorScheme.onError,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class NPostFABold extends StatefulWidget {
//   // Define a GlobalKey
//   final GlobalKey fabKey;

//   // NewPostFloatingActionButton({
//   //   super.key,
//   // });

//   const NPostFABold({required this.fabKey, Key? key}) : super(key: key);

//   @override
//   State<NPostFABold> createState() => _NPostFABoldState();
// }

// bool isNewPostAddable =
//     requestUploadStatus.value == RequestUploadStatus.normal ||
//         requestUploadStatus.value == RequestUploadStatus.uploaded;

// class _NPostFABoldState extends State<NPostFABold> {
//   bool _isPressed = false;
//   final ValueNotifier<Color> colorNotifier =
//       ValueNotifier<Color>(lightColorScheme.primary);

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<RequestUploadStatus>(
//       valueListenable: requestUploadStatus,
//       builder: (context, value, child) {
//         isNewPostAddable = value == RequestUploadStatus.normal ||
//             value == RequestUploadStatus.uploaded;
//         colorNotifier.value = (isNewPostAddable)
//             ? lightColorScheme.primary
//             : lightColorScheme.outline;

//         return AnimatedBuilder(
//           animation: colorNotifier,
//           builder: (context, child) {
//             return Hero(
//               tag: 'postButton',
//               child: GestureDetector(
//                 key: widget.fabKey,
//                 onTapDown: (details) {
//                   setState(() {
//                     _isPressed = true;
//                   });
//                 },
//                 onTapUp: (details) {
//                   Future.delayed(const Duration(milliseconds: 200), () {
//                     setState(() {
//                       _isPressed = false;
//                     });
//                   });
//                 },
//                 onTapCancel: () {
//                   setState(() {
//                     _isPressed = false;
//                   });
//                 },
//                 onTap: (value == RequestUploadStatus.normal)
//                     ? () {
//                         // Get the position of the FAB

//                         // final RenderBox? renderBox = fabKey.currentContext!
//                         //     .findRenderObject() as RenderBox?;
//                         // final Offset? position =
//                         //     renderBox?.localToGlobal(Offset.zero);

//                         final RenderBox? renderBox =
//                             widget.fabKey.currentContext!.findRenderObject()
//                                 as RenderBox?;
//                         final Offset? position = renderBox
//                             ?.localToGlobal(renderBox.size.center(Offset.zero));

//                         // Calculate the distance to the farthest corner
//                         final distance = position != null
//                             ? sqrt(pow(position.dx, 2) + pow(position.dy, 2))
//                             : 0;
//                         Future.delayed(const Duration(milliseconds: 100), () {
//                           Navigator.push(
//                               context,
//                               PageRouteBuilder(
//                                 pageBuilder:
//                                     (context, animation, secondaryAnimation) {
//                                   return const NewPostPage();
//                                 },
//                                 transitionDuration:
//                                     const Duration(milliseconds: 3000),
//                                 reverseTransitionDuration:
//                                     const Duration(milliseconds: 800),
//                                 transitionsBuilder: (context, animation,
//                                     secondaryAnimation, child) {
//                                   final curvedAnimation = CurvedAnimation(
//                                     parent: animation,
//                                     curve: const Cubic(0.79, 0.01, 0.29, 1.09),
//                                   );

//                                   return Stack(children: [
//                                     // Overlay a semi-transparent black layer that fades in as the animation progresses
//                                     AnimatedBuilder(
//                                       animation: curvedAnimation,
//                                       builder: (context, child) {
//                                         return BackdropFilter(
//                                           filter: ImageFilter.blur(
//                                               sigmaX:
//                                                   15 * curvedAnimation.value,
//                                               sigmaY:
//                                                   15 * curvedAnimation.value),
//                                           child: Container(
//                                             color: backgroundAnimationColor
//                                                 .withOpacity(0.7 *
//                                                     curvedAnimation.value),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     // AnimatedBuilder(
//                                     //     animation: curvedAnimation,
//                                     //     builder: (context, child) {
//                                     //       return ClipPath(
//                                     //         clipper: CircleClipper(
//                                     //             curvedAnimation.value
//                                     //                 .toDouble(),
//                                     //             position!,
//                                     //             distance.toDouble()),
//                                     //         child: child,
//                                     //       );
//                                     //     },
//                                     //     child: child),
//                                   ]);
//                                 },
//                               ));
//                         });
//                       }
//                     : () {
//                         // requestUploadStatus.value = 'Normal';
//                       },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   decoration: BoxDecoration(
//                     color: _isPressed ? Colors.grey[400] : colorNotifier.value,
//                     borderRadius: BorderRadius.circular(_isPressed ? 15 : 50),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(_isPressed ? 0.3 : 0.2),
//                         spreadRadius: _isPressed ? 2 : 1,
//                         blurRadius: _isPressed ? 10 : 7,
//                         offset: Offset(0,
//                             _isPressed ? 5 : 3), // changes position of shadow
//                       ),
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(16),
//                   child: (isNewPostAddable)
//                       ? Icon(
//                           Icons.add,
//                           color: (isNewPostAddable)
//                               ? (_isPressed)
//                                   ? lightColorScheme.secondary
//                                   : lightColorScheme.onPrimary
//                               : lightColorScheme.onError,
//                         )
//                       : PulsingChild(
//                           child: Icon(
//                             // Icons.arrow_circle_up_rounded,
//                             Icons.circle_outlined,
//                             color: lightColorScheme.onError,
//                           ),
//                         ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

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
