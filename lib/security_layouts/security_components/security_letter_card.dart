import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/deleter.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/main.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_deleter.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_transmitter.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/security_layouts/security_components/security_theme.dart';
import 'package:lofo/services/notification_terminal.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

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
      required this.cardCategory,
      required this.cardPosterID,
      this.cardHandedOverTo});

  final int cardType; // 0 for Public, 1 for Inbox
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
  // final Image userImage;
  final String userImageURL;
  final String cardPosterID;

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
        cardHandedOverTo,
        cardName,
        cardImageURL,
        userImageURL,
        context,
        cardPosterID);
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
    String? cardHandedOverTo,
    String cardName,
    String? cardImageURL,
    String posterImageURL,
    BuildContext context,
    String cardPosterID) {
  themeData = Theme.of(context);
  if (cardName == 'Chief Security Officer IIT Indore') {
    cardName = 'CSO';
  }
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
              securityCardLocationInfo(cardLocation, cardCategory),
              const SizedBox(height: 10),
              securityCardTimeInfo(cardTimeMisplaced),
              // const SizedBox(height: 12),
              securityHandedOverToInfoRow(cardHandedOverTo),
              securityCardActionRow(
                  cardType,
                  cardID,
                  cardImageURL,
                  cardCategory,
                  cardPostedAt,
                  cardPosterID,
                  cardTitle,
                  cardDescription,
                  cardLocation,
                  cardTimeMisplaced,
                  cardHandedOverTo,
                  cardName,
                  posterImageURL,
                  context),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget securityCardActionRow(
    int cardType,
    String cardID,
    String? cardImageURL,
    int cardCategory,
    String cardPostedAt,
    String cardPosterID,
    String cardTitle,
    String cardDescription,
    String cardLocation,
    String? cardTimeLastSeen,
    String? cardHandedOverTo,
    String userName,
    String loginProfileImageURL,
    BuildContext context) {
  Row type1ActionRow() {
    // security card is in inbox page

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BasicButton.secondaryButton('Contact', () async {
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
        }),
        const SizedBox(width: 10),
        // BasicButton.warningSecondaryButton('Delete', () async {
        // show confirmation popover
        SecurityConfirmatoryButton(
          buttonText: 'Delete',
          buttonType: ButtonType.warningSecondary,
          parentContext: context,
          actionOnPressed: () async {
            // dismiss pop over
            Navigator.pop(context);
            // initiate deletion of private request

            SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
                securityRequestUploadStatus.value;

            securityRequestUploadStatus.value =
                SecurityRequestUploadStatus.deleting;

            await midLoginCheck().then((isLoginValid) async {
              if (isLoginValid) {
                // delete private request

                await deleteRequest(cardID, cardImageURL).then((isDeleted) {
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
          },
        ),
        // }),
        const SizedBox(width: 10),
        // BasicButton.secondaryButton('Publicize', () async {
        SecurityConfirmatoryButton(
            buttonText: 'Publicize',
            buttonType: ButtonType.secondary,
            parentContext: context,
            actionOnPressed: () async {
              // close popover
              Navigator.pop(context);
              // initiate publicizing of private request

              SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
                  securityRequestUploadStatus.value;

              securityRequestUploadStatus.value =
                  SecurityRequestUploadStatus.publicizing;

              void publicizeCompletion(
                  SecurityRequestUploadStatus
                      previousSecurityRequestUploadStatus) {
                securityRequestUploadStatus.value =
                    SecurityRequestUploadStatus.publicized;
                Timer(const Duration(seconds: 1), () {
                  securityRequestUploadStatus.value =
                      previousSecurityRequestUploadStatus;
                });
              }

              void publicizeFailure(
                  SecurityRequestUploadStatus
                      previousSecurityRequestUploadStatus) {
                securityRequestUploadStatus.value =
                    SecurityRequestUploadStatus.publicizeError;
                Timer(const Duration(seconds: 1), () {
                  securityRequestUploadStatus.value =
                      previousSecurityRequestUploadStatus;
                });
              }

              DateTime cardPostedAtDatetime = DateTime.now();
              // String yearLastTwoDigits =
              //     cardPostedAtDatetime.year.toString().substring(2);
              // String cardID =
              //     '${loginID?.substring(0, loginID!.length - 10)}${cardPostedAtDatetime.day}.${cardPostedAtDatetime.month}.$yearLastTwoDigits.${cardPostedAtDatetime.hour}:${cardPostedAtDatetime.minute}:${cardPostedAtDatetime.second}';

              String cardPostedAt =
                  '${cardPostedAtDatetime.year}-${cardPostedAtDatetime.month.toString().padLeft(2, '0')}-${cardPostedAtDatetime.day.toString().padLeft(2, '0')} ${cardPostedAtDatetime.hour.toString().padLeft(2, '0')}:${cardPostedAtDatetime.minute.toString().padLeft(2, '0')}:${cardPostedAtDatetime.second.toString().padLeft(2, '0')}.${cardPostedAtDatetime.millisecond.toString().padLeft(3, '0')}';

              await midLoginCheck().then((isLoginValid) async {
                if (isLoginValid) {
                  // send request to public
                  await sendSecurityPublicizeRequest(
                          cardCategory,
                          cardPostedAt,
                          cardID,
                          cardPosterID,
                          cardTitle,
                          cardDescription,
                          cardLocation,
                          cardTimeLastSeen,
                          cardHandedOverTo,
                          userName,
                          loginProfileImageURL,
                          null,
                          cardImageURL)
                      .then((isSendSuccessful) async {
                    if (isSendSuccessful) {
                      // deleter request from private
                      await deleteRequest(cardID, null).then(
                        (isDeleted) {
                          if (isDeleted) {
                            publicizeCompletion(
                                previousSecurityRequestUploadStatus);
                          } else {
                            publicizeFailure(
                                previousSecurityRequestUploadStatus);
                          }
                        },
                      );

                      // send notification to security
                      await NotificationTerminal.sendPublicizeNotifications(
                          cardPosterID, cardTitle, userName, cardCategory);
                    } else {
                      publicizeFailure(previousSecurityRequestUploadStatus);
                    }
                  });
                } else {
                  previousSecurityRequestUploadStatus =
                      SecurityRequestUploadStatus.someThingWentWrong;
                  publicizeFailure(previousSecurityRequestUploadStatus);
                }
              });
            }),
      ],
    );
  }

  if (cardType == 0) {
    // security card is in home page

    return
        // BasicButton.warningSecondaryButton('Delete', () async {
        SecurityConfirmatoryButton(
      buttonText: 'Delete',
      buttonType: ButtonType.warningSecondary,
      parentContext: context,
      actionOnPressed: () async {
        // dismiss pop over
        Navigator.pop(context);

        // initiate deletion of public post
        SecurityRequestUploadStatus previousSecurityRequestUploadStatus =
            securityRequestUploadStatus.value;

        securityRequestUploadStatus.value =
            SecurityRequestUploadStatus.deleting;

        await midLoginCheck().then((isLoginValid) async {
          if (isLoginValid) {
            await deleteSecurityRequest(cardID, cardImageURL).then((isDeleted) {
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
      },
    );
    // });
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
      securityCardCategoryBox(cardCategory),
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

Row securityCardLocationInfo(String cardLocation, int cardCategory) {
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

Row securityCardTimeInfo(String? cardLeftBehindAt) {
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
                Text('Time Last seen: $cardLeftBehindAt'),
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

Row securityHandedOverToInfoRow(String? cardHandedOverTo) {
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

GestureDetector securityCardLetterImage(
    String? cardImageURL, BuildContext context) {
  if (cardImageURL != null && cardImageURL.isNotEmpty) {
    Image cardImage = Image.network(cardImageURL);
    return GestureDetector(
      onTap: () {
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
      color: securityColorScheme.onSurface,
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
