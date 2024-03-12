import 'package:flutter/material.dart';

class LetterCardInfo {
  int cardCategory;
  DateTime cardPostedAt;
  String cardID;
  String cardPosterID;
  String cardTitle;
  String cardDescription;
  String cardLocation;
  String? cardTimeMisplaced;
  String cardName;
  Image? cardImage;
  Image userImage;

  LetterCardInfo(
      {required this.cardCategory,
      required this.cardPostedAt,
      required this.cardPosterID,
      required this.cardID,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeMisplaced,
      required this.cardName,
      required this.cardImage,
      required this.userImage});
}
