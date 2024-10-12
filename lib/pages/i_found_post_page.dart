import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lofo/backend/CRUD/transmitter.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/basic_text_form_field.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/components/navigation.dart';
import 'package:lofo/main.dart';
import 'package:lofo/services/verify_app_validity.dart';
import 'package:lofo/theme/default_theme.dart';

class IFoundPostPage extends StatefulWidget {
  const IFoundPostPage({super.key});

  @override
  State<IFoundPostPage> createState() => _IFoundPostPageState();
}

class _IFoundPostPageState extends State<IFoundPostPage> {
  File? pickedPostImage;
  int postCategory = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController leftBehindAtController = TextEditingController();
  TextEditingController handedOverToController = TextEditingController();
  DateTime? timeMisplaced;

  int sentTimer = 3;

  final _formKey = GlobalKey<FormState>();
  final isRequestPostable = ValueNotifier<bool>(false);
  final isRequestFilledAdequately = ValueNotifier<bool>(false);

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    leftBehindAtController.dispose();
    handedOverToController.dispose();
    pickedPostImage = null;
    super.dispose();
  }

  Future<void> _pickPostImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if (pickedImage != null) {
      setState(() {
        pickedPostImage = File(pickedImage.path);
      });
    }
  }

  void nullifyNewPostPatameters() {
    setState(() {
      pickedPostImage = null;
      titleController.clear();
      descriptionController.clear();
      locationController.clear();
      leftBehindAtController.clear();
      handedOverToController.clear();
    });
  }

  postAction(
    BuildContext context,
    int postCategory,
    String postTitle,
    String postDescription,
    String postLocation,
    String? postTimeLastSeen,
    String handedOverTo,
    String userImageURL,
    File? pickedPostImage,
  ) async {
    RequestUploadStatus previousRequestUploadStatus = requestUploadStatus.value;

    requestUploadStatus.value = RequestUploadStatus.uploading;

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

    await midLoginCheck().then((isLoginValid) async {
      if (isLoginValid) {
        await sendFoundRequest(
                postCategory,
                cardPostedAt,
                cardID,
                loginID!,
                postTitle,
                postDescription,
                postLocation,
                postTimeLastSeen,
                handedOverTo,
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
        previousRequestUploadStatus = RequestUploadStatus.someThingWentWrong;
        sendFailure(previousRequestUploadStatus);
      }
    });
  }

  void sendCompletion(RequestUploadStatus previousRequestUploadStatus) {
    requestUploadStatus.value = RequestUploadStatus.uploaded;
    Timer(const Duration(seconds: 1), () {
      requestUploadStatus.value = previousRequestUploadStatus;
    });
  }

  void sendFailure(RequestUploadStatus previousRequestUploadStatus) {
    requestUploadStatus.value = RequestUploadStatus.uploadError;
    Timer(const Duration(seconds: 1), () {
      requestUploadStatus.value = previousRequestUploadStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    void updateIsRequestPostable() {
      // isRequestPostable.value = _formKey.currentState?.validate() ?? false;
      isRequestFilledAdequately.value =
          titleController.text.trim().isNotEmpty &&
              descriptionController.text.trim().isNotEmpty &&
              locationController.text.trim().isNotEmpty &&
              handedOverToController.text.trim().isNotEmpty;
    }

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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    uploadImageButton(),
                    const SizedBox(height: 20),
                    // basicDropDownFormField(),
                    // const SizedBox(height: 20),
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
                      maxLines: 15,
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
                      labelText: 'Location found',
                      textController: locationController,
                      onChanged: updateIsRequestPostable,
                    ),
                    const SizedBox(height: 20),
                    BasicTextFormField(
                      maxLength: 20,
                      maxLines: 1,
                      // readOnly: true,
                      isRequiredField: false,
                      labelText: 'Time found',
                      textController: leftBehindAtController,
                      onChanged: updateIsRequestPostable,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Please hand over this item to a nearby security agent, and mention their location below.',
                      style: TextStyle(
                          fontSize: 15,
                          color: themeData.colorScheme.onSurfaceVariant,
                          fontFamily: fonts[1],
                          fontVariations: const [FontVariation('wght', 400)]),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    BasicTextFormField(
                      maxLength: 20,
                      maxLines: 1,
                      // readOnly: true,
                      isRequiredField: true,
                      labelText: 'Handed over at',
                      textController: handedOverToController,
                      onChanged: updateIsRequestPostable,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'This request will be sent to the security, and they might choose to make it public.',
                      style: TextStyle(
                          fontSize: 15,
                          color: themeData.colorScheme.onSurfaceVariant,
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
                                            RequestUploadStatus
                                                previousRequestUploadStatus =
                                                requestUploadStatus.value;

                                            requestUploadStatus.value =
                                                RequestUploadStatus.validating;

                                            await verifyAppValidity()
                                                .then((isValid) {
                                              requestUploadStatus.value =
                                                  previousRequestUploadStatus;

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
                                                    handedOverToController.text
                                                        .trim(),
                                                    loginProfileImageURL,
                                                    pickedPostImage);
                                              } else {
                                                requestUploadStatus.value =
                                                    RequestUploadStatus
                                                        .someThingWentWrong;
                                                // Navigator.pop(context);
                                              }
                                            });
                                          }
                                          if (!mounted) return;
                                          setState(() {
                                            selectedPageIndex = 2;
                                          });
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

  ElevatedButton uploadImageButton() {
    return ElevatedButton(
        onPressed: () {
          try {
            _pickPostImage();
          } catch (e) {
            debugPrint('Error: $e');
          }
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: themeData.colorScheme.primaryContainer,
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
                  : themeData.colorScheme.primaryContainer,
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
                      Icons.add_photo_alternate_rounded,
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

  // DropdownButtonFormField<int> basicDropDownFormField() {
  //   Text basicDropDownFormText(String text) {
  //     return Text(
  //       text,
  //       style: TextStyle(
  //         fontSize: 18,
  //         fontFamily: fonts[1],
  //         fontVariations: const [FontVariation('wght', 400)],
  //       ),
  //     );
  //   }

  //   return DropdownButtonFormField(
  //     value: postCategory,
  //     items: [
  //       DropdownMenuItem(
  //         value: 1,
  //         child: basicDropDownFormText('I have lost ...'),
  //       ),
  //       DropdownMenuItem(
  //         value: 0,
  //         child: basicDropDownFormText('I have found ...'),
  //       ),
  //     ],
  //     elevation: 6,
  //     onChanged: (value) {
  //       postCategory = value!;
  //       debugPrint('post category : $postCategory');
  //     },
  //     decoration: InputDecoration(
  //       border: InputBorder.none,
  //       enabledBorder: UnderlineInputBorder(
  //           borderSide: const BorderSide(
  //             color: Colors.transparent,
  //           ),
  //           borderRadius: BorderRadius.circular(8)),
  //       focusedBorder: UnderlineInputBorder(
  //           borderSide: const BorderSide(
  //             color: Colors.transparent,
  //           ),
  //           borderRadius: BorderRadius.circular(8)),
  //       fillColor: themeData.colorScheme.tertiary,
  //       filled: true,
  //     ),
  //   );
  // }
}
