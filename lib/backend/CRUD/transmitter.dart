// import 'dart:ui';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/services/verify_app_validity.dart';

Future<bool> sendRequest(
  int postCategory,
  String postPostedAt,
  String postID,
  String postPosterID,
  String postTitle,
  String postDescription,
  String postLocation,
  String? postTimeLastSeen,
  String postName,
  String userImageURL,
  File? postImage,
  // Image? postImage,
  // Image userImage,
) async {
  if (await verifyAppValidity()) {
    try {
      String postImageURL = '';
      if (postImage != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('postImages/$postID');

        await storageRef.putFile(postImage);

        postImageURL = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('privateRequests')
          .doc(postID)
          .set({
        'postName': postName,
        'postID': postID,
        'postTitle': postTitle,
        'postDescription': postDescription,
        'postLocation': postLocation,
        'postTimeLastSeen': postTimeLastSeen,
        'postCategory': postCategory,
        'postPostedAt': postPostedAt,
        'postPosterID': postPosterID,
        // 'image': postImage,
        'postImageURL': postImageURL,
        'userImageURL': userImageURL,
      });
      return true;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  } else {
    requestUploadStatus.value = RequestUploadStatus.someThingWentWrong;
    return false;
  }
}

Future<bool> sendFoundRequest(
  int postCategory,
  String postPostedAt,
  String postID,
  String postPosterID,
  String postTitle,
  String postDescription,
  String postLocation,
  String? postTimeLastSeen,
  String postHandedOverTo,
  String postName,
  String userImageURL,
  File? postImage,
  // Image? postImage,
  // Image userImage,
) async {
  if (await verifyAppValidity()) {
    try {
      String postImageURL = '';
      if (postImage != null) {
        final storageRef =
            FirebaseStorage.instance.ref().child('postImages/$postID');

        await storageRef.putFile(postImage);

        postImageURL = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('privateRequests')
          .doc(postID)
          .set({
        'postName': postName,
        'postID': postID,
        'postTitle': postTitle,
        'postDescription': postDescription,
        'postLocation': postLocation,
        'postTimeLastSeen': postTimeLastSeen,
        'postHandedOverTo': postHandedOverTo,
        'postCategory': postCategory,
        'postPostedAt': postPostedAt,
        'postPosterID': postPosterID,
        // 'image': postImage,
        'postImageURL': postImageURL,
        'userImageURL': userImageURL,
      });
      return true;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  } else {
    requestUploadStatus.value = RequestUploadStatus.someThingWentWrong;
    return false;
  }
}

Future<bool> midLoginCheck() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    debugPrint('$e');
    return false;
  }
}
