import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/theme/light_theme.dart';

class LetterCard extends StatelessWidget {
  const LetterCard(
      {super.key,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardLeftBehindAt,
      required this.cardName,
      required this.cardImage,
      required this.userImage});

  final String cardTitle;
  final String cardDescription;
  final String cardLocation;
  final String cardLeftBehindAt;
  final String cardName;
  // final String cardImage = 'assets/images/photo-1643804926339-e94f0a655185.png';
  final Image cardImage;
  final Image userImage;

  @override
  Widget build(BuildContext context) {
    return cardLayout(cardTitle, cardDescription, cardLocation,
        cardLeftBehindAt, cardName, cardImage, userImage);
  }
}

Column cardLayout(
    String cardTitle,
    String cardDescription,
    String cardLocation,
    String cardLeftBehindAt,
    String cardName,
    Image cardImage,
    Image posterImage) {
  return Column(
    children: [
      const SizedBox(height: 20),
      posterInfoRow(posterImage, cardName),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  letterImage(cardImage),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        cardTitle,
                        style: TextStyle(
                            fontFamily: fonts[1],
                            fontVariations: const [FontVariation('wght', 440)],
                            fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cardDescription,
                        style: const TextStyle(
                            fontVariations: [FontVariation('wght', 400)]),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              locationInfo(cardLocation),
              const SizedBox(height: 10),
              timeInfo(cardLeftBehindAt),
              const SizedBox(height: 12),
              BasicButton.secondaryButton('Claim', () {}),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Row posterInfoRow(Image posterImage, String cardName) {
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
        style: const TextStyle(
            fontFamily: 'Manrope',
            fontVariations: [FontVariation('wght', 600)],
            fontSize: 15),
      ),
    ],
  );
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

Row timeInfo(String cardLeftBehindAt) {
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
}

Container letterImage(Image cardImage) {
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
}
