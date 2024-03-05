import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/basic_text_box.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/theme/light_theme.dart';

File? pickedPostImage;
TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController leftBehindAtController = TextEditingController();

int sentTimer = 3;

class CustomNavigatorObserver extends NavigatorObserver {
  final Function onPop;

  CustomNavigatorObserver({required this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop();
    super.didPop(route, previousRoute);
  }
}

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  // @override
  // void initState() {
  //   nullifyNewPostPatameters();
  //   super.initState();
  // }

  Future<void> _pickPostImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage != null) {
      setState(() {
        pickedPostImage = File(pickedImage.path);
      });
    }
  }

  void nullifyNewPostPatameters() {
    setState(() {
      debugPrint(titleController.text);
      debugPrint(descriptionController.text);
      debugPrint(locationController.text);
      debugPrint(leftBehindAtController.text);
      pickedPostImage = null;
      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      leftBehindAtController.clear();
    });
  }

  void postAction(BuildContext context) {
    requestUploadStatus.value = 'Uploading';

    // code for uploading the post to firebase

    nullifyNewPostPatameters();
    Navigator.pop(context);
    setState(() {});

    Timer(Duration(seconds: sentTimer), () {
      sendCompletion();
    });
  }

  void sendCompletion() {
    requestUploadStatus.value = 'Uploaded';
    Timer(const Duration(seconds: 1), () {
      requestUploadStatus.value = 'Normal';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        nullifyNewPostPatameters();
        Navigator.pop(context);
      },
    );
    return PopScope(
      onPopInvoked: (didPop) {
        nullifyNewPostPatameters();
      },
      child: Scaffold(
          appBar: appBar('New Request', null, leading: leading),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  uploadImageButton(),
                  const SizedBox(height: 20),
                  BasicTextBox(
                      maxLength: 20,
                      labelText: 'Title',
                      textController: titleController),
                  const SizedBox(height: 20),
                  BasicTextBox(
                      maxLength: 100,
                      labelText: 'Description',
                      textController: descriptionController),
                  const SizedBox(height: 20),
                  BasicTextBox(
                      maxLength: 30,
                      labelText: 'Location',
                      textController: locationController),
                  const SizedBox(height: 20),
                  BasicTextBox(
                      maxLength: 20,
                      labelText: 'Left Behind At',
                      textController: leftBehindAtController),
                  const SizedBox(height: 20),
                  Hero(
                      tag: 'postButton',
                      child: BasicButton.primaryButton(
                          'Post', () => postAction(context))),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )),
    );
  }

  ElevatedButton uploadImageButton() {
    return ElevatedButton(
        onPressed: () {
          _pickPostImage();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: secondaryButtonBackgroundSolidColor,
            shadowColor: Colors.transparent,
            elevation: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: const Cubic(0.63, 0, 0, 1),
          height: pickedPostImage != null ? 400 : 250,
          width: double.infinity,
          decoration: BoxDecoration(
              color: pickedPostImage != null
                  ? Colors.transparent
                  : secondaryButtonBackgroundSolidColor,
              borderRadius: BorderRadius.circular(8),
              image: (pickedPostImage != null)
                  ? DecorationImage(
                      image: FileImage(pickedPostImage!), fit: BoxFit.cover)
                  : null),
          child: (pickedPostImage != null)
              ? null
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 100,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Upload Image',
                            style: TextStyle(
                                fontSize: 20,
                                fontVariations: [FontVariation('wght', 400)])),
                      ],
                    ),
                  ],
                ),
        ));
  }
}
