import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/components/pulsing_child.dart';
import 'package:lofo/components/shower_thoughts.dart';
import 'package:lofo/main.dart';
import 'package:path_provider/path_provider.dart';

// import 'dart:io';
// import 'package:provider/provider.dart';
bool areCamerasAvailable = false;

List<CameraDescription> cameras = [];

Future<void> reInitCamera() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
  }
  // runApp(MyApp());
  // const CameraPage();
}

class CameraPage extends StatefulWidget {
  // const CameraPage({super.key, required this.camera});
  const CameraPage({
    super.key,
  });

  // CameraDescription? camera;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
        cameraDescription, ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
      // _showTextAlert('Error initializing camera: $e');
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CameraExceptionPage(
            message: 'Error initializing camera: $e',
          );
        }));
      }
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
    // _textFieldController.dispose();
    _isCapturing = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // Free up memory when camera not active
      cameraController.dispose();
      _isCameraInitialized = false;
    } else if (state == AppLifecycleState.resumed) {
      reInitCamera();
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  bool _isCapturing = false;

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      _showTextAlert('Error occured while taking picture: $e');
      return null;
    }
  }

  Future<void> oldShowDialog(
      BuildContext context, ColorScheme colorScheme, image) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter Server URL',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            content: TextField(
              onChanged: (value) {},
              // controller: _textFieldController,
              decoration: const InputDecoration(
                  hintText: "http://your-matlab-server-ip:3000"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  // code for https request
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => DescriptionPage(image: image)));
                },
                child: const Text('UPLOAD'),
              ),
            ],
          );
        });
  }

  void _showImageDialog(image) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.fromLTRB(1.0, 10, 1.0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // const SizedBox(height: 10),
                ],
              ),
            ),
            actions: <Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                    child: BasicButton.secondaryButton("Retake", () {
                  Navigator.of(context).pop();
                  controller!.resumePreview();
                })),

                const SizedBox(width: 18),

                Expanded(
                    child: BasicButton.primaryButton("Proceed", () {
                  Navigator.pop(context);
                  Navigator.pop(context, image);
                })),

                // Expanded(
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       controller!.resumePreview();
                //     },
                //     child: const Text('Retake'),
                //   ),
                // ),
              ]),
            ],
          );
        });
      },
    );
  }

  void _showTextAlert(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
                Navigator.of(context).pop(); // Close the camera page
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: (brightness == Brightness.light)
          ? colorScheme.onSurface
          : colorScheme.surface,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: (brightness == Brightness.light)
              ? colorScheme.onSurface
              : colorScheme.surface, // Navigation bar
          statusBarColor: Colors.transparent, // Status bar
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
            color: (brightness == Brightness.light)
                ? colorScheme.surface
                : colorScheme.onSurfaceVariant //change your color here
            ),
        backgroundColor: (brightness == Brightness.light)
            ? colorScheme.onSurface
            : colorScheme.surface,
        title: Text('Camera Preview',
            style: TextStyle(
                color: (brightness == Brightness.light)
                    ? colorScheme.surface
                    : colorScheme.onSurfaceVariant)),
        centerTitle: true,
      ),
      body: _isCameraInitialized
          ? Center(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      // color: colorScheme.surface,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // child: AspectRatio(
                      //   aspectRatio: 1 / controller!.value.aspectRatio,
                      //   child: controller!.buildPreview(),
                      // ),
                      child: controller!.buildPreview(),
                    ),
                  ),

                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Center(
                                  child: photoShutterButton(
                                      colorScheme, brightness))),
                        ),
                        Expanded(
                            child: AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          child: _isCapturing
                              ? Center(
                                  child: CircularProgressIndicator(
                                  color: (brightness == Brightness.light)
                                      ? colorScheme.surface
                                      : colorScheme.onSurface,
                                ))
                              : const SizedBox(),
                        )
                            // child: const SizedBox(),
                            ),
                        // videoRecordButton(),
                        // cameraFlipButton(),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 5,
                  // )
                ],
              ),
            )
          : Center(
              // when camera is not initialized
              child: CircularProgressIndicator(
              color: colorScheme.surface,
            )),
    );
  }

  IconButton photoShutterButton(
    colorScheme,
    Brightness brightness,
  ) {
    return IconButton(
      icon: const Icon(
        Icons.camera_rounded,
        size: 75,
      ),
      color: (brightness == Brightness.light)
          ? (_isCapturing
              ? colorScheme.surface.withAlpha(150)
              : colorScheme.surface)
          : (_isCapturing
              ? colorScheme.onSurfaceVariant.withAlpha(150)
              : colorScheme.onBackground),
      onPressed: (_isCapturing)
          ? () {
              // do nothing, to disable the button when caputring
            }
          : () async {
              // checkIfCapturing();
              setState(() {
                _isCapturing = true;
              });
              XFile? rawImage = await takePicture();
              File imageFile = File(rawImage!.path);

              int currentUnix = DateTime.now().millisecondsSinceEpoch;
              final directory = await getApplicationDocumentsDirectory();
              String fileFormat = imageFile.path.split('.').last;

              await imageFile.copy(
                '${directory.path}/$currentUnix.$fileFormat',
              );

              final pickedImage = rawImage;
              File? image;
              setState(() {
                image = File(pickedImage.path);
                _isCapturing = false;
              });
              _showImageDialog(image);
              controller!.pausePreview();
            },
    );
  }
}

class PreCamLoadPage extends StatefulWidget {
  const PreCamLoadPage({super.key});

  @override
  State<PreCamLoadPage> createState() => _PreCamLoadPageState();
}

class _PreCamLoadPageState extends State<PreCamLoadPage> {
  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (mounted) {
        if (cameras.isNotEmpty) {
          final capturedImage = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraPage()),
          );
          if (mounted) {
            Navigator.pop(context, capturedImage); // Pass the image back
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CameraErrorPage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CameraErrorPage()),
        );
      }
      debugPrint('Error initializing cameras: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: PulsingChild(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_rounded,
                    size: 100, color: themeData.colorScheme.secondary),
                const SizedBox(
                  height: 30,
                ),
                Text(
                    "Looking for cameras \n \n If you're stuck here for long, enable camera permission in settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeData.colorScheme.secondary,
                      fontSize: 20,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CameraErrorPage extends StatelessWidget {
  final String? message;
  const CameraErrorPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Icon(Icons.no_photography,
                  size: 100, color: themeData.colorScheme.secondary),
              const SizedBox(
                height: 40,
              ),
              Text(ShowerThoughts().getThought(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeData.colorScheme.secondary,
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 30,
              ),
              Text((message == null) ? 'Couldn\'t find cameras' : message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeData.colorScheme.secondary,
                    fontSize: 20,
                  )),
              const SizedBox(
                height: 60,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeData.colorScheme.tertiary,
                  ),
                  child: Center(
                    child: Text('Head back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeData.colorScheme.secondary,
                          fontSize: 20,
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CameraExceptionPage extends StatelessWidget {
  final String message;
  const CameraExceptionPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var brightness = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: (brightness == Brightness.light)
          ? colorScheme.onSurface
          : colorScheme.surface,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: (brightness == Brightness.light)
              ? colorScheme.onSurface
              : colorScheme.surface, // Navigation bar
          statusBarColor: Colors.transparent, // Status bar
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
            color: (brightness == Brightness.light)
                ? colorScheme.surface
                : colorScheme.onSurfaceVariant //change your color here
            ),
        backgroundColor: (brightness == Brightness.light)
            ? colorScheme.onSurface
            : colorScheme.surface,
        title: Text('Camera Preview',
            style: TextStyle(
                color: (brightness == Brightness.light)
                    ? colorScheme.surface
                    : colorScheme.onSurfaceVariant)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                // color: colorScheme.surface,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                // child: AspectRatio(
                //   aspectRatio: 1 / controller!.value.aspectRatio,
                //   child: controller!.buildPreview(),
                // ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Icon(Icons.error_outline_rounded,
                            size: 100, color: themeData.colorScheme.secondary),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeData.colorScheme.secondary,
                              fontSize: 20,
                            )),
                        const SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorScheme.onSurface,
                            ),
                            child: Center(
                              child: Text('Head back',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorScheme.secondary,
                                    fontSize: 20,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const SafeArea(
            //   child: SizedBox(
            //     height: 5,
            //   ),
            // ),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.camera_rounded,
                        color: themeData.colorScheme.surface.withAlpha(150),
                        size: 75,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // )
          ],
        ),
      ),
    );
  }
}
