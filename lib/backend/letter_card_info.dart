import 'package:flutter/material.dart';

class LetterCardInfo {
  DateTime cardPostedAt;
  String cardID;
  String cardTitle;
  String cardDescription;
  String cardLocation;
  String? cardTimeMisplaced;
  String cardName;
  Image? cardImage;
  Image userImage;

  LetterCardInfo(
      {required this.cardPostedAt,
      required this.cardID,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeMisplaced,
      required this.cardName,
      required this.cardImage,
      required this.userImage});
}
