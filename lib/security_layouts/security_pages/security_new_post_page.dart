import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofo/components/basic_text_form_field.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';

File? pickedPostImage;
int postCategory = 0;
TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController leftBehindAtController = TextEditingController();
DateTime? timeMisplaced;

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

class SecurityNewPostPage extends StatefulWidget {
  const SecurityNewPostPage({super.key});

  @override
  State<SecurityNewPostPage> createState() => _SecurityNewPostPageState();
}

class _SecurityNewPostPageState extends State<SecurityNewPostPage> {
  // @override

  // void initState() {
  //   nullifyNewPostPatameters();
  //   super.initState();
  // }

  final _formKey = GlobalKey<FormState>();
  final isRequestPostable = ValueNotifier<bool>(false);
  final isRequestFilledAdequately = ValueNotifier<bool>(false);

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
    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploading;

    // code for uploading the post to firebase

    nullifyNewPostPatameters();
    Navigator.pop(context);
    setState(() {});

    Timer(Duration(seconds: sentTimer), () {
      sendFailure();
    });
  }

  void sendCompletion() {
    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploaded;
    Timer(const Duration(seconds: 1), () {
      securityRequestUploadStatus.value = SecurityRequestUploadStatus.normal;
    });
  }

  void sendFailure() {
    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploadError;
    Timer(const Duration(seconds: 1), () {
      securityRequestUploadStatus.value = SecurityRequestUploadStatus.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    void updateIsRequestPostable() {
      // isRequestPostable.value = _formKey.currentState?.validate() ?? false;
      isRequestFilledAdequately.value = titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          locationController.text.isNotEmpty;
    }

    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      color: securityColorScheme.onBackground,
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
          appBar: securityAppBar('New Request', null, leading: leading),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    uploadImageButton(),
                    const SizedBox(height: 20),
                    basicSecurityDropDownFormField(),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 40,
                      maxLines: 1,
                      isRequiredField: true,
                      labelText: 'Title',
                      textController: titleController,
                      onChanged: updateIsRequestPostable,
                    ),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 100,
                      maxLines: null,
                      isRequiredField: true,
                      labelText: 'Description',
                      textController: descriptionController,
                      onChanged: updateIsRequestPostable,
                    ),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 30,
                      maxLines: 1,
                      isRequiredField: false,
                      labelText: 'Location',
                      textController: locationController,
                      onChanged: updateIsRequestPostable,
                    ),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 20,
                      maxLines: 1,
                      // readOnly: true,
                      isRequiredField: false,
                      labelText: 'Time last seen',
                      textController: leftBehindAtController,
                      onChanged: updateIsRequestPostable,
                      // onTap: () {
                      //   showTimePicker(
                      //     context: context,
                      //     initialTime: TimeOfDay.now(),
                      //   ).then((time) {
                      //     if (time != null) {
                      //       leftBehindAtController.text =
                      //           '${time.hour}:${time.minute}';
                      //     }
                      //   });
                      // },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'This request will be sent to the security, and they might choose to make it public.',
                      style: TextStyle(
                          fontSize: 15,
                          color: secondaryTextColor,
                          fontFamily: fonts[1],
                          fontVariations: const [FontVariation('wght', 400)]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                        valueListenable: isRequestFilledAdequately,
                        builder: (context, isRequestFilledAdequately, child) {
                          return Hero(
                              tag: 'postButton',
                              child: BasicButton.primaryButton(
                                  'Send',
                                  isRequestFilledAdequately
                                      ? () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            postAction(context);
                                          }
                                        }
                                      : null));
                        }),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  DropdownButtonFormField<int> basicSecurityDropDownFormField() {
    Text basicDropDownFormText(String text) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: fonts[1],
          fontVariations: const [FontVariation('wght', 400)],
        ),
      );
    }

    return DropdownButtonFormField(
      value: postCategory,
      items: [
        DropdownMenuItem(
          value: 1,
          child: basicDropDownFormText('I have lost ...'),
        ),
        DropdownMenuItem(
          value: 0,
          child: basicDropDownFormText('I have found ...'),
        ),
      ],
      onChanged: (value) {
        postCategory = value!;
        debugPrint('post category : $postCategory');
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(8)),
        fillColor: colorScheme.surfaceVariant,
        filled: true,
      ),
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
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: securityColorScheme.primary,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Upload Image',
                            style: TextStyle(
                                color: securityColorScheme.primary,
                                fontSize: 20,
                                fontVariations: const [
                                  FontVariation('wght', 400)
                                ])),
                      ],
                    ),
                  ],
                ),
        ));
  }
}
