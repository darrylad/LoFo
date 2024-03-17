class LetterCardInfo {
  int cardCategory;
  String cardPostedAt;
  String cardID;
  String cardPosterID;
  String cardTitle;
  String cardDescription;
  String cardLocation;
  String? cardTimeLastSeen;
  String cardName;
  String? cardImageURL;
  // Image? userImage;
  String? userImageURL;

  LetterCardInfo(
      {required this.cardCategory,
      required this.cardPostedAt,
      required this.cardPosterID,
      required this.cardID,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeLastSeen,
      required this.cardName,
      required this.cardImageURL,
      // this.userImage,
      this.userImageURL});
}
