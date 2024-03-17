import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';

Future<bool> deleteSecurityRequest(String postID, String? postImageURL) async {
  SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
      securityRequestUploadStatus.value;
  securityRequestUploadStatus.value = SecurityRequestUploadStatus.deleting;
  try {
    var db = FirebaseFirestore.instance;
    await db.collection('publicRequests').doc(postID).delete();

    if (postImageURL != null && postImageURL.isNotEmpty) {
      final storageRef =
          FirebaseStorage.instance.ref().child('postImages/$postID');

      await storageRef.delete();
    }

    securityDeleteSuccess(previousSecurityRequestUploadStatus);

    return true;
  } catch (e) {
    debugPrint(e.toString());
    securityDeleteFailure(previousSecurityRequestUploadStatus);
    return false;
  }
}

void securityDeleteSuccess(
    SecurityRequestUploadStatus previousSecurityRequestUploadStatus) {
  securityRequestUploadStatus.value = SecurityRequestUploadStatus.deleted;
  Timer(const Duration(seconds: 1), () {
    securityRequestUploadStatus.value = previousSecurityRequestUploadStatus;
  });
}

void securityDeleteFailure(
    SecurityRequestUploadStatus previousRequestUploadStatus) {
  securityRequestUploadStatus.value = SecurityRequestUploadStatus.deleteError;
  Timer(const Duration(seconds: 1), () {
    securityRequestUploadStatus.value = previousRequestUploadStatus;
  });
}
