import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/theme/light_theme.dart';
import 'package:photo_view/photo_view.dart';

class LetterCard extends StatelessWidget {
  const LetterCard(
      {super.key,
      required this.cardTitle,
      required this.cardID,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeMisplaced,
      required this.cardName,
      required this.cardImage,
      required this.userImage,
      required this.cardPostedAt,
      required this.cardCategory});

  final int cardCategory; // 0 for found, 1 for lost
  final String cardTitle;
  final String cardID;
  final DateTime cardPostedAt;
  final String cardDescription;
  final String cardLocation;
  final String? cardTimeMisplaced;
  final String cardName;
  // final String cardImage = 'assets/images/photo-1643804926339-e94f0a655185.png';
  final Image? cardImage;
  final Image userImage;

  @override
  Widget build(BuildContext context) {
    return cardLayout(
        cardCategory,
        cardID,
        cardTitle,
        cardPostedAt,
        cardDescription,
        cardLocation,
        cardTimeMisplaced,
        cardName,
        cardImage,
        userImage,
        context);
  }
}

Column cardLayout(
    int cardCategory,
    String cardID,
    String cardTitle,
    DateTime cardPostedAt,
    String cardDescription,
    String cardLocation,
    String? cardTimeMisplaced,
    String cardName,
    Image? cardImage,
    Image posterImage,
    BuildContext context) {
  return Column(
    children: [
      const SizedBox(height: 20),
      posterInfoRow(cardCategory, posterImage, cardName, cardPostedAt),
      const SizedBox(height: 10),
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  letterImage(cardImage, context),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          cardTitle,
                          maxLines: null,
                          style: TextStyle(
                              fontFamily: fonts[1],
                              fontVariations: const [
                                FontVariation('wght', 440)
                              ],
                              fontSize: 20),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          cardDescription,
                          maxLines: null,
                          softWrap: true,
                          style: const TextStyle(
                              fontVariations: [FontVariation('wght', 400)]),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              locationInfo(cardLocation),
              const SizedBox(height: 10),
              timeInfo(cardTimeMisplaced),
              const SizedBox(height: 12),
              BasicButton.secondaryButton('Claim', () {
                debugPrint('Claim button pressed');
                debugPrint('Card ID: $cardID');
                debugPrint('Card Title: $cardTitle');
              }),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Row posterInfoRow(int cardCategory, Image posterImage, String cardName,
    DateTime cardPostedAt) {
  String yearLastTwoDigits = cardPostedAt.year.toString().substring(2);
  String formattedDate =
      '${cardPostedAt.day}/${cardPostedAt.month}/$yearLastTwoDigits at ${cardPostedAt.hour}:${cardPostedAt.minute}';
  return Row(
    children: [
      const SizedBox(width: 15),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: posterImage.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        cardName,
        style: TextStyle(
            fontFamily: fonts[0],
            fontVariations: const [FontVariation('wght', 600)],
            fontSize: 15),
      ),
      const SizedBox(width: 5),
      cardCategoryBox(cardCategory),
      const Spacer(),
      Text(
        formattedDate.toString(),
        style: TextStyle(
            fontFamily: fonts[1],
            color: Colors.blueGrey[300],
            fontVariations: const [FontVariation('wght', 400)],
            fontSize: 14),
      ),
      const SizedBox(width: 15),
    ],
  );
}

Container cardCategoryBox(int cardCategory) {
  // 0 for found, 1 for lost

  Text cardCategoryText(String cardCategoryText) {
    return Text(cardCategoryText,
        style: TextStyle(
          fontFamily: fonts[0],
          fontSize: 13,
          color: Colors.white,
          fontVariations: const [FontVariation('wght', 600)],
        ));
  }

  if (cardCategory == 0) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.green[800],
      ),
      child: cardCategoryText('Found'),
    );
  } else if (cardCategory == 1) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: lightColorScheme.primary,
      ),
      child: cardCategoryText('Lost'),
    );
  } else {
    return Container(width: 0);
  }
}

Row locationInfo(String cardLocation) {
  return Row(
    children: [
      const Icon(
        Icons.location_on_outlined,
        size: 20,
      ),
      const SizedBox(width: 10),
      Text('Location: $cardLocation'),
    ],
  );
}

Row timeInfo(String? cardLeftBehindAt) {
  if (cardLeftBehindAt != null) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text('Left behind at: $cardLeftBehindAt'),
      ],
    );
  } else {
    return const Row();
  }
}

GestureDetector letterImage(Image? cardImage, BuildContext context) {
  if (cardImage != null) {
    return GestureDetector(
      onTap: () {
        debugPrint('Card image pressed');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PhotoViewerPage(
                    cardImage: cardImage,
                  )),
        );
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 131, 125),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: cardImage.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  } else {
    return GestureDetector(
      child: Container(
        width: 0,
      ),
    );
  }
}

class PhotoViewerPage extends StatelessWidget {
  final Image cardImage;
  const PhotoViewerPage({super.key, required this.cardImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('', null),
      body: Center(
          child: PhotoView(
        imageProvider: cardImage.image,
        enableRotation: true,
      )),
    );
  }
}
