import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/deleter.dart';
import 'package:lofo/backend/CRUD/transmitter.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_deleter.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:photo_view/photo_view.dart';

class SecurityLetterCard extends StatelessWidget {
  const SecurityLetterCard(
      {super.key,
      required this.cardTitle,
      required this.cardDescription,
      required this.cardLocation,
      required this.cardTimeLastSeen,
      required this.cardName,
      required this.cardImageURL,
      required this.userImageURL,
      required this.cardPostedAt,
      required this.cardID,
      required this.cardType,
      required this.cardCategory});

  final int cardType; // 0 for Public, 1 for Inbox
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
  // final Image userImage;
  final String userImageURL;

  @override
  Widget build(BuildContext context) {
    return securityCardLayout(
        cardCategory,
        cardID,
        cardType,
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

Column securityCardLayout(
    int cardCategory,
    String cardID,
    int cardType,
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
      securityCardPosterInfoRow(
          cardCategory, posterImageURL, cardName, cardPostedAt),
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
                  securityCardLetterImage(cardImageURL, context),
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
              securityCardActionRow(cardType, cardID, cardImageURL),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget securityCardActionRow(
    int cardType, String cardID, String? cardImageURL) {
  Row type1ActionRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BasicButton.warningSecondaryButton('Delete', () async {
          SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
              securityRequestUploadStatus.value;

          await midLoginCheck().then((isLoginValid) {
            if (isLoginValid) {
              deleteRequest(cardID, cardImageURL).then((isDeleted) {
                if (isDeleted) {
                  securityDeleteSuccess(previousSecurityRequestUploadStatus);
                } else {
                  securityDeleteFailure(previousSecurityRequestUploadStatus);
                }
              });
            } else {
              previousSecurityRequestUploadStatus =
                  SecurityRequestUploadStatus.someThingWentWrong;
              securityDeleteFailure(previousSecurityRequestUploadStatus);
            }
          });
        }),
        const SizedBox(width: 10),
        BasicButton.secondaryButton('Publicize', () {}),
      ],
    );
  }

  if (cardType == 0) {
    // security card is in home page
    return BasicButton.warningSecondaryButton('Delete', () async {
      SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
          securityRequestUploadStatus.value;

      await midLoginCheck().then((isLoginValid) {
        if (isLoginValid) {
          deleteSecurityRequest(cardID, cardImageURL).then((isDeleted) {
            if (isDeleted) {
              securityDeleteSuccess(previousSecurityRequestUploadStatus);
            } else {
              securityDeleteFailure(previousSecurityRequestUploadStatus);
            }
          });
        } else {
          previousSecurityRequestUploadStatus =
              SecurityRequestUploadStatus.someThingWentWrong;
          securityDeleteFailure(previousSecurityRequestUploadStatus);
        }
      });
    });
  } else if (cardType == 1) {
    // security card is in inbox page
    return type1ActionRow();
  } else {
    return const SizedBox();
  }
}

Row securityCardPosterInfoRow(int cardCategory, String posterImageURL,
    String cardName, String cardPostedAt) {
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
      securityCardCategoryBox(cardCategory),
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

Container securityCardCategoryBox(int cardCategory) {
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
        color: securityColorScheme.onPrimary,
      ),
      child: cardCategoryText('Lost'),
    );
  } else {
    return Container(width: 0);
  }
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
  if (cardLeftBehindAt != null && cardLeftBehindAt.isNotEmpty) {
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

GestureDetector securityCardLetterImage(
    String? cardImageURL, BuildContext context) {
  if (cardImageURL != null && cardImageURL.isNotEmpty) {
    Image cardImage = Image.network(cardImageURL);
    return GestureDetector(
      onTap: () {
        debugPrint('Card image pressed');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecurityPhotoViewerPage(
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

class SecurityPhotoViewerPage extends StatelessWidget {
  final Image cardImage;
  const SecurityPhotoViewerPage({super.key, required this.cardImage});

  @override
  Widget build(BuildContext context) {
    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      color: securityColorScheme.background,
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return Scaffold(
      appBar: securityAppBar('', null, leading: leading),
      body: Center(
          child: PhotoView(
        imageProvider: cardImage.image,
        enableRotation: true,
      )),
    );
  }
}
