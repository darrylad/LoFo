import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/deleter.dart';
import 'package:lofo/backend/CRUD/transmitter.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/theme/default_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class LetterCard extends StatelessWidget {
  const LetterCard({
    super.key,
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
    required this.cardType,
    required this.cardPosterID,
    this.cardHandedOverTo,
    this.isArchived,
    // required this.parentContext
  });

  final int cardType; // 0 for home, 1 for your posts
  final int cardCategory; // 0 for found, 1 for lost
  final String cardTitle;
  final String cardID;
  final String cardPostedAt;
  final String cardDescription;
  final String cardLocation;
  final String? cardTimeLastSeen;
  final String? cardHandedOverTo;
  final String cardName;
  // final String cardImage = 'assets/images/photo-1643804926339-e94f0a655185.png';
  final String? cardImageURL;
  final String userImageURL;
  final String cardPosterID;
  final bool? isArchived;
  // final BuildContext parentContext;

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
        cardHandedOverTo,
        cardName,
        cardImageURL,
        userImageURL,
        context,
        cardPosterID,
        isArchived);
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
    String? cardHandedOverTo,
    String cardName,
    String? cardImageURL,
    String posterImageURL,
    BuildContext context,
    String cardPosterID,
    bool? cardArchived) {
  themeData = Theme.of(context);
  if (cardName == 'Chief Security Officer IIT Indore') {
    cardName = 'CSO';
  }
  return Column(
    children: [
      const SizedBox(height: 15),
      Opacity(
          opacity: cardArchived ?? false ? 0.5 : 1,
          child: posterInfoRow(
              cardCategory, posterImageURL, cardName, cardPostedAt)),
      const SizedBox(height: 10),
      Container(
        color: themeData.colorScheme.tertiary,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              archivedRow(cardArchived ?? false),

              const SizedBox(height: 10),
              Opacity(
                opacity: cardArchived ?? false ? 0.3 : 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    letterImage(cardImageURL, context),
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
              ),
              const SizedBox(height: 15),

              Opacity(
                  opacity: cardArchived ?? false ? 0.3 : 1,
                  child: locationInfo(cardLocation, cardCategory)),
              const SizedBox(height: 10),

              Opacity(
                  opacity: cardArchived ?? false ? 0.3 : 1,
                  child: timeInfo(cardTimeMisplaced)),

              Opacity(
                  opacity: cardArchived ?? false ? 0.3 : 1,
                  child: handedOverToInfoRow(cardHandedOverTo)),

              actionButtonRow(cardID, cardTitle, cardType, cardImageURL,
                  context, cardPosterID, cardArchived ?? false),

              // const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget archivedRow(bool isArchived) {
  return (isArchived)
      ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.archive_outlined,
              color: ColorScheme.fromSeed(
                      brightness: themeData.brightness,
                      seedColor: Colors.orange)
                  .primary,
            ),
            const SizedBox(width: 10),
            Text(
              'Archived',
              style: TextStyle(
                  fontFamily: fonts[0],
                  fontVariations: const [FontVariation('wght', 600)],
                  color: ColorScheme.fromSeed(
                          brightness: themeData.brightness,
                          seedColor: Colors.orange)
                      .primary,
                  fontSize: 15),
            ),
          ],
        )
      : const SizedBox();
}

Widget actionButtonRow(
    String cardID,
    String cardTitle,
    int cardType,
    String? cardImageURL,
    BuildContext parentContext,
    String cardPosterID,
    bool isArchived) {
  if (cardType == 0) {
    // card is displayed in home page

    // return BasicButton.secondaryButton('Ping', () {
    //   debugPrint('Claim button pressed');
    //   debugPrint('Card ID: $cardID');
    //   debugPrint('Card Title: $cardTitle');
    // });

    return (cardPosterID == loginID)
        ? archiveButton(isArchived, cardID, false, parentContext)
        : BasicButton.secondaryButton('Mail', () async {
            final Uri params =
                Uri(scheme: 'mailto', path: cardPosterID, query: '');

            try {
              if (await canLaunchUrl(params)) {
                await launchUrl(params);
              } else {
                throw 'Could not launch $params';
              }
            } catch (e) {
              debugPrint('Error: $e');
            }
          });
    // return const SizedBox();
  } else if (cardType == 1) {
    return archiveButton(isArchived, cardID, true, parentContext);

    // BasicButton.warningSecondaryButton('Delete', () async {
//         (isArchived)
//             ? ConfirmatoryButton(
//                 buttonText: 'Unarchive',
//                 buttonType: ButtonType.secondary,
//                 parentContext: parentContext,
//                 actionOnPressed: () async {
//                   Navigator.pop(parentContext);

//                   // initiate deletion of private request

//                   RequestUploadStatus previousRequestUploadStatus =
//                       requestUploadStatus.value;

//                   requestUploadStatus.value = RequestUploadStatus.unArchiving;

//                   await midLoginCheck().then((isLoginValid) async {
//                     if (isLoginValid) {
//                       await unArchiveRequest(cardID)
//                           .then((isUnarchiveSuccessful) {
//                         if (isUnarchiveSuccessful) {
//                           unArchiveSuccess(previousRequestUploadStatus);
//                         } else {
//                           unArchiveFailure(previousRequestUploadStatus);
//                         }
//                       });
//                     } else {
//                       previousRequestUploadStatus =
//                           RequestUploadStatus.someThingWentWrong;
//                       unArchiveFailure(previousRequestUploadStatus);
//                     }
//                   });
//                 },
//               )
//             : ConfirmatoryButton(
//                 buttonType: ButtonType.warningSecondary,
//                 buttonText: 'Archive',
//                 parentContext: parentContext,
//                 // parentContext: parentContext,
//                 actionOnPressed: () async {
// // dismiss pop over
//                   Navigator.pop(parentContext);

//                   // initiate deletion of private request

//                   RequestUploadStatus previousRequestUploadStatus =
//                       requestUploadStatus.value;

//                   requestUploadStatus.value = RequestUploadStatus.archiving;

//                   await midLoginCheck().then((isLoginValid) async {
//                     if (isLoginValid) {
//                       // await deleteRequest(cardID, cardImageURL)
//                       //     .then((isDeleteSuccessful) {
//                       //   if (isDeleteSuccessful) {
//                       //     deleteSuccess(previousRequestUploadStatus);
//                       //   } else {
//                       //     deleteFailure(previousRequestUploadStatus);
//                       //   }
//                       // });

//                       await archiveRequest(cardID).then((isArchiveSuccessful) {
//                         if (isArchiveSuccessful) {
//                           archiveSuccess(previousRequestUploadStatus);
//                         } else {
//                           archiveFailure(previousRequestUploadStatus);
//                         }
//                       });
//                     } else {
//                       previousRequestUploadStatus =
//                           RequestUploadStatus.someThingWentWrong;
//                       archiveFailure(previousRequestUploadStatus);
//                     }
//                   });
//                 });
  } else {
    return const SizedBox();
  }
}

ConfirmatoryButton archiveButton(
    bool isArchived, String cardID, bool private, BuildContext parentContext) {
  return (isArchived)
      ? ConfirmatoryButton(
          buttonText: 'Unarchive',
          buttonType: ButtonType.secondary,
          parentContext: parentContext,
          actionOnPressed: () async {
            Navigator.pop(parentContext);

            // initiate deletion of private request

            RequestUploadStatus previousRequestUploadStatus =
                requestUploadStatus.value;

            requestUploadStatus.value = RequestUploadStatus.unArchiving;

            await midLoginCheck().then((isLoginValid) async {
              if (isLoginValid) {
                await unArchiveRequest(cardID, private)
                    .then((isUnarchiveSuccessful) {
                  if (isUnarchiveSuccessful) {
                    unArchiveSuccess(previousRequestUploadStatus);
                  } else {
                    unArchiveFailure(previousRequestUploadStatus);
                  }
                });
              } else {
                previousRequestUploadStatus =
                    RequestUploadStatus.someThingWentWrong;
                unArchiveFailure(previousRequestUploadStatus);
              }
            });
          },
        )
      : ConfirmatoryButton(
          buttonType: ButtonType.warningSecondary,
          buttonText: 'Archive',
          parentContext: parentContext,
          // parentContext: parentContext,
          actionOnPressed: () async {
// dismiss pop over
            Navigator.pop(parentContext);

            // initiate deletion of private request

            RequestUploadStatus previousRequestUploadStatus =
                requestUploadStatus.value;

            requestUploadStatus.value = RequestUploadStatus.archiving;

            await midLoginCheck().then((isLoginValid) async {
              if (isLoginValid) {
                // await deleteRequest(cardID, cardImageURL)
                //     .then((isDeleteSuccessful) {
                //   if (isDeleteSuccessful) {
                //     deleteSuccess(previousRequestUploadStatus);
                //   } else {
                //     deleteFailure(previousRequestUploadStatus);
                //   }
                // });

                await archiveRequest(cardID, private)
                    .then((isArchiveSuccessful) {
                  if (isArchiveSuccessful) {
                    archiveSuccess(previousRequestUploadStatus);
                  } else {
                    archiveFailure(previousRequestUploadStatus);
                  }
                });
              } else {
                previousRequestUploadStatus =
                    RequestUploadStatus.someThingWentWrong;
                archiveFailure(previousRequestUploadStatus);
              }
            });
          });
}

Row posterInfoRow(int cardCategory, String posterImageURL, String cardName,
    String cardPostedAt) {
  DateTime cardPostedAtDatetime = DateTime.parse(cardPostedAt);
  String yearLastTwoDigits = cardPostedAtDatetime.year.toString().substring(2);
  String formattedDate =
      '${cardPostedAtDatetime.day}/${cardPostedAtDatetime.month}/$yearLastTwoDigits at ${cardPostedAtDatetime.hour}:${cardPostedAtDatetime.minute.toString().padLeft(2, '0')}';
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
      Expanded(
        child: Text(
          cardName,
          style: TextStyle(
              fontFamily: fonts[0],
              fontVariations: const [FontVariation('wght', 600)],
              fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 5),
      cardCategoryBox(cardCategory),
      // const Spacer(),
      const SizedBox(width: 10),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          formattedDate.toString(),
          style: TextStyle(
              fontFamily: fonts[1],
              color: Colors.blueGrey[300],
              fontVariations: const [FontVariation('wght', 400)],
              fontSize: 14),
        ),
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
        Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text('Time last seen: $cardLeftBehindAt'),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ],
    );
  } else {
    return const Row();
  }
}

Row handedOverToInfoRow(String? cardHandedOverTo) {
  if (cardHandedOverTo != null && cardHandedOverTo.isNotEmpty) {
    return Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.security_outlined,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text('Handed over to: $cardHandedOverTo'),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ],
    );
  } else {
    return const Row();
  }
}

Widget letterImage(String? cardImageURL, BuildContext context) {
  if (cardImageURL != null && cardImageURL.isNotEmpty) {
    Image cardImage = Image.network(cardImageURL);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PhotoViewerPage(
                    cardImage: cardImage,
                  )),
        );
      },
      child: Row(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: cardImage.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  } else {
    return const SizedBox();
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
