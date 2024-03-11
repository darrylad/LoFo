import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';

class SecurityLetterCard extends StatelessWidget {
  const SecurityLetterCard(
      {super.key,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeMisplaced,
      required this.cardName,
      required this.cardImage,
      required this.userImage,
      required this.cardPostedAt});

  final String cardTitle;
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
    return securityCardLayout(cardTitle, cardPostedAt, cardDescription,
        cardLocation, cardTimeMisplaced, cardName, cardImage, userImage);
  }
}

Column securityCardLayout(
    String cardTitle,
    DateTime cardPostedAt,
    String cardDescription,
    String cardLocation,
    String? cardTimeMisplaced,
    String cardName,
    Image? cardImage,
    Image posterImage) {
  return Column(
    children: [
      const SizedBox(height: 20),
      securityCardPosterInfoRow(posterImage, cardName, cardPostedAt),
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
                  securityCardLetterImage(cardImage),
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
              securityCardLocationInfo(cardLocation),
              const SizedBox(height: 10),
              securityCardTimeInfo(cardTimeMisplaced),
              const SizedBox(height: 12),
              BasicButton.warningSecondaryButton('Delete', () {}),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Row securityCardPosterInfoRow(
    Image posterImage, String cardName, DateTime cardPostedAt) {
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

Row securityCardLocationInfo(String cardLocation) {
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

Row securityCardTimeInfo(String? cardLeftBehindAt) {
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

Container securityCardLetterImage(Image? cardImage) {
  if (cardImage != null) {
    return Container(
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
    );
  } else {
    return Container(
      width: 0,
    );
  }
}
