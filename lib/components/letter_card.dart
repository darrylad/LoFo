import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/deleter.dart';
import 'package:lofo/backend/CRUD/transmitter.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';
import 'package:photo_view/photo_view.dart';

class LetterCard extends StatelessWidget {
  const LetterCard(
      {super.key,
      required this.cardTitle,
      required this.cardID,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeLastSeen,
      required this.cardName,
      required this.cardImageURL,
      required this.userImageURL,
      required this.cardPostedAt,
      required this.cardCategory,
      required this.cardType});

  final int cardType; // 0 for home, 1 for your posts
  final int cardCategory; // 0 for found, 1 for lost
  final String cardTitle;
  final String cardID;
  final String cardPostedAt;
  final String cardDescription;
  final String cardLocation;
  final String? cardTimeLastSeen;
  final String cardName;
  // final String cardImage = 'assets/images/photo-1643804926339-e94f0a655185.png';
  final String? cardImageURL;
  final String userImageURL;

  @override
  Widget build(BuildContext context) {
    return cardLayout(
        cardType,
        cardCategory,
        cardID,
        cardTitle,
        cardPostedAt,
        cardDescription,
        cardLocation,
        cardTimeLastSeen,
        cardName,
        cardImageURL,
        userImageURL,
        context);
  }
}

Column cardLayout(
    int cardType,
    int cardCategory,
    String cardID,
    String cardTitle,
    String cardPostedAt,
    String cardDescription,
    String cardLocation,
    String? cardTimeMisplaced,
    String cardName,
    String? cardImageURL,
    String posterImageURL,
    BuildContext context) {
  themeData = Theme.of(context);
  return Column(
    children: [
      const SizedBox(height: 20),
      posterInfoRow(cardCategory, posterImageURL, cardName, cardPostedAt),
      const SizedBox(height: 10),
      Container(
        color: themeData.colorScheme.tertiary,
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
                  letterImage(cardImageURL, context),
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
              locationInfo(cardLocation, cardCategory),
              const SizedBox(height: 10),
              timeInfo(cardTimeMisplaced),
              const SizedBox(height: 12),
              actionButtonRow(cardID, cardTitle, cardType, cardImageURL),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget actionButtonRow(
    String cardID, String cardTitle, int cardType, String? cardImageURL) {
  if (cardType == 0) {
    // card is displayed in home page
    return BasicButton.secondaryButton('Ping', () {
      debugPrint('Claim button pressed');
      debugPrint('Card ID: $cardID');
      debugPrint('Card Title: $cardTitle');
    });
  } else if (cardType == 1) {
    return BasicButton.warningSecondaryButton('Delete', () async {
      debugPrint('Delete button pressed');
      debugPrint('Card ID: $cardID');

      // initiate deletion of private request

      RequestUploadStatus previousRequestUploadStatus =
          requestUploadStatus.value;

      requestUploadStatus.value = RequestUploadStatus.deleting;

      await midLoginCheck().then((isLoginValid) async {
        if (isLoginValid) {
          await deleteRequest(cardID, cardImageURL).then((isDeleteSuccessful) {
            if (isDeleteSuccessful) {
              deleteSuccess(previousRequestUploadStatus);
            } else {
              deleteFailure(previousRequestUploadStatus);
            }
          });
        } else {
          previousRequestUploadStatus = RequestUploadStatus.someThingWentWrong;
          deleteFailure(previousRequestUploadStatus);
        }
      });
    });
  } else {
    return const SizedBox();
  }
}

Row posterInfoRow(int cardCategory, String posterImageURL, String cardName,
    String cardPostedAt) {
  DateTime cardPostedAtDatetime = DateTime.parse(cardPostedAt);
  String yearLastTwoDigits = cardPostedAtDatetime.year.toString().substring(2);
  String formattedDate =
      '${cardPostedAtDatetime.day}/${cardPostedAtDatetime.month}/$yearLastTwoDigits at ${cardPostedAtDatetime.hour}:${cardPostedAtDatetime.minute}';
  return Row(
    children: [
      const SizedBox(width: 15),
      Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(posterImageURL),
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

Row locationInfo(String cardLocation, int cardCategory) {
  Widget locationText(String cardLocation, int cardCategory) {
    if (cardCategory == 0) {
      // found
      return Text('Location found: $cardLocation');
    } else if (cardCategory == 1) {
      //lost
      return Text('Location lost: $cardLocation');
    } else {
      return const SizedBox();
    }
  }

  return Row(
    children: [
      const Icon(
        Icons.location_on_outlined,
        size: 20,
      ),
      const SizedBox(width: 10),
      locationText(cardLocation, cardCategory),
    ],
  );
}

Row timeInfo(String? cardLeftBehindAt) {
  if (cardLeftBehindAt != null && cardLeftBehindAt.isNotEmpty) {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text('Time last seen: $cardLeftBehindAt'),
      ],
    );
  } else {
    return const Row();
  }
}

GestureDetector letterImage(String? cardImageURL, BuildContext context) {
  if (cardImageURL != null && cardImageURL.isNotEmpty) {
    Image cardImage = Image.network(cardImageURL);
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
          color: secondaryButtonBackGroundColor,
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
