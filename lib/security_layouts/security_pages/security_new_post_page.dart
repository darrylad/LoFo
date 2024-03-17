import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/basic_text_form_field.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_transmitter.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/services/verify_app_validity.dart';

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
  File? pickedPostImage;
  int postCategory = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController leftBehindAtController = TextEditingController();
  DateTime? timeMisplaced;

  int sentTimer = 3;

  // @override

  // void initState() {
  //   nullifyNewPostPatameters();
  //   super.initState();
  // }

  final _formKey = GlobalKey<FormState>();
  final isRequestPostable = ValueNotifier<bool>(false);
  final isRequestFilledAdequately = ValueNotifier<bool>(false);

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    leftBehindAtController.dispose();
    pickedPostImage = null;
    super.dispose();
  }

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

  // void postAction(BuildContext context) {
  //   securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploading;

  //   // code for uploading the post to firebase

  //   nullifyNewPostPatameters();
  //   Navigator.pop(context);
  //   setState(() {});

  //   Timer(Duration(seconds: sentTimer), () {
  //     sendFailure();
  //   });
  // }

  postAction(
    BuildContext context,
    int postCategory,
    String postTitle,
    String postDescription,
    String postLocation,
    String? postTimeLastSeen,
    String userImageURL,
    File? pickedPostImage,
  ) async {
    SecurityRequestUploadStatus previousRequestUploadStatus =
        securityRequestUploadStatus.value;

    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploading;

    DateTime cardPostedAtDatetime = DateTime.now();
    String yearLastTwoDigits =
        cardPostedAtDatetime.year.toString().substring(2);
    String cardID =
        '${loginID?.substring(0, loginID!.length - 10)}${cardPostedAtDatetime.day}.${cardPostedAtDatetime.month}.$yearLastTwoDigits.${cardPostedAtDatetime.hour}:${cardPostedAtDatetime.minute}:${cardPostedAtDatetime.second}';

    debugPrint('cardPostedAtDatetime: $cardPostedAtDatetime');

    String cardPostedAt =
        '${cardPostedAtDatetime.year}-${cardPostedAtDatetime.month.toString().padLeft(2, '0')}-${cardPostedAtDatetime.day.toString().padLeft(2, '0')} ${cardPostedAtDatetime.hour.toString().padLeft(2, '0')}:${cardPostedAtDatetime.minute.toString().padLeft(2, '0')}:${cardPostedAtDatetime.second.toString().padLeft(2, '0')}.${cardPostedAtDatetime.millisecond.toString().padLeft(3, '0')}';
    debugPrint('cardPostedAt: $cardPostedAt');
    debugPrint('cardID: $cardID');

    // await sendRequest(
    //         postCategory,
    //         cardPostedAt,
    //         cardID,
    //         loginID!,
    //         titleController.text,
    //         descriptionController.text,
    //         locationController.text,
    //         leftBehindAtController.text,
    //         userName!,
    //         loginProfileImageURL)
    //     .then((sendStatus) {
    //   if (sendStatus == 0) {
    //     sendCompletion(previousRequestUploadStatus);
    //   } else if (sendStatus == 2) {
    //     previousRequestUploadStatus = RequestUploadStatus.someThingWentWrong;
    //     sendFailure(previousRequestUploadStatus);
    //   } else {
    //     sendFailure(previousRequestUploadStatus);
    //   }
    // });

    await midLoginCheck().then((isLoginValid) async {
      if (isLoginValid) {
        await sendSecurityRequest(
                postCategory,
                cardPostedAt,
                cardID,
                loginID!,
                postTitle,
                postDescription,
                postLocation,
                postTimeLastSeen,
                userName!,
                loginProfileImageURL,
                pickedPostImage)
            .then((isSendSuccessful) {
          if (isSendSuccessful) {
            sendCompletion(previousRequestUploadStatus);
          } else {
            sendFailure(previousRequestUploadStatus);
          }
        });
      } else {
        previousRequestUploadStatus =
            SecurityRequestUploadStatus.someThingWentWrong;
        sendFailure(previousRequestUploadStatus);
      }
    });

    // if (!mounted) return;
    // nullifyNewPostPatameters();
    // setState(() {});
    // if (isSendSuccessful) {
    //   sendCompletion();
    // } else {
    //   sendFailure();
    // }
    // Timer(Duration(seconds: sentTimer), () {
    //   sendFailure();
    // });
  }

  void sendCompletion(
      SecurityRequestUploadStatus previousSecurityRequestUploadStatus) {
    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploaded;
    Timer(const Duration(seconds: 1), () {
      securityRequestUploadStatus.value = previousSecurityRequestUploadStatus;
    });
  }

  void sendFailure(
      SecurityRequestUploadStatus previousSecurityRequestUploadStatus) {
    securityRequestUploadStatus.value = SecurityRequestUploadStatus.uploadError;
    Timer(const Duration(seconds: 1), () {
      securityRequestUploadStatus.value = previousSecurityRequestUploadStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

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
                      maxLength: 50,
                      maxLines: 1,
                      isRequiredField: true,
                      labelText: 'Title',
                      textController: titleController,
                      onChanged: updateIsRequestPostable,
                    ),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 250,
                      maxLines: null,
                      isRequiredField: true,
                      labelText: 'Notes, and where to collect',
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
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            await verifyAppValidity()
                                                .then((isValid) {
                                              debugPrint('isValid: $isValid');
                                              if (isValid) {
                                                postAction(
                                                    context,
                                                    postCategory,
                                                    titleController.text.trim(),
                                                    descriptionController.text
                                                        .trim(),
                                                    locationController.text
                                                        .trim(),
                                                    leftBehindAtController.text
                                                        .trim(),
                                                    loginProfileImageURL,
                                                    pickedPostImage);
                                              } else {
                                                securityRequestUploadStatus
                                                        .value =
                                                    SecurityRequestUploadStatus
                                                        .someThingWentWrong;
                                                // Navigator.pop(context);
                                              }
                                            });
                                          }
                                          if (!mounted) return;
                                          Navigator.pop(this.context);
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
        fillColor: themeData.colorScheme.tertiary,
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
