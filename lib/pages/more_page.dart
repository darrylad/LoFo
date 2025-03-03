import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lofo/animation/logout_intermediate.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/components/button.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';
import 'package:lofo/onboarding/onboarding.dart';
import 'package:lofo/pages/about_page.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';
import 'package:lofo/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool useMyAccountAsSecurityAccount = false;

ValueNotifier<bool> forceLightTheme = ValueNotifier<bool>(false);

String appURL = 'null';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool isLoading = false;

  saveForceLightTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('forceLightTheme', forceLightTheme.value);
  }

  final Uri _url = Uri.parse(appURL);

  Future<void> _launchUrl() async {
    try {
      // if (!await launchUrl(_url)) {
      //   throw Exception('Could not launch $_url');
      // }
      await launchUrl(_url);
    } on Exception catch (e) {
      debugPrint('Could not launch $_url: $e');
    }
  }

  Future<void> logoutRitual() async {
    // await NotificationService().unsubscribeSecurityFromTopic();
    // await NotificationService().unsubscribeUsersFromTopic();
    // await NotificationService().disableNotifications();
    if (Platform.isAndroid) {
      await NotificationService().completelyDisableNotifications();
    }

    await performLogout();
  }

  showConformatoryLogoutDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout?'),
            titleTextStyle: themeData.textTheme.titleLarge,
            content: const Text(
                'Your account instance will be removed, but your posts will not be deleted, and will reappear when you log back in.'),
            actions: [
              BasicButton.secondaryButton("Cancel", () {
                Navigator.pop(context, false);
              }),
              const SizedBox(
                height: 10,
              ),
              BasicButton.warningPrimaryButton("Logout", () {
                Navigator.pop(context, true);
              }),
            ],
          );
        });
  }

  showLoadingDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Loggin out..."),
            titleTextStyle: themeData.textTheme.titleLarge,
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    // width: 50,
                    height: 50,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LinearProgressIndicator(),
                    ))),
                SizedBox(height: 10),
                Text(
                  'Hang tight ... this might take a few seconds',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
        // appBar: appBar('Hi, Darryl', userImageExample),
        body: ListView(children: [
      // const SizedBox(height: 20),
      // appBarChangeButtonRow(),
      const SizedBox(height: 20),
      // Hero(
      //   tag: 'about',
      //   child: Material(
      //     type: MaterialType.transparency,
      //     child: ListTile(
      //       title: Text('About', style: themeData.textTheme.bodyLarge),
      //       onTap: () {
      //         Navigator.push(
      //             context,
      //             PageRouteBuilder(
      //               pageBuilder: (context, animation, secondaryAnimation) =>
      //                   const AboutPage(),
      //               transitionsBuilder:
      //                   (context, animation, secondaryAnimation, child) {
      //                 return SlideTransition(
      //                   position: Tween<Offset>(
      //                     begin: const Offset(0, 1),
      //                     end: Offset.zero,
      //                   ).animate(animation),
      //                   child: child,
      //                 );
      //               },
      //             ));
      //       },
      //     ),
      //   ),
      // ),

      // (devSwitch) ? devSwitchWid() : const SizedBox(),

      ListTile(
        title: const Text("Replay onboarding"),
        onTap: () {
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const Onboarding();
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ));
        },
      ),

      SwitchListTile(
          value: forceLightTheme.value,
          title: Text(
            'Force light theme',
            style: themeData.textTheme.bodyLarge,
          ),
          onChanged: (value) {
            setState(() {
              forceLightTheme.value = value;
            });
            saveForceLightTheme();
          }),
      // (appURL != 'null')
      //     ? ListTile(
      //         title: Text(
      //           'View source code',
      //           style: themeData.textTheme.bodyLarge,
      //         ),
      //         trailing: const Icon(Icons.open_in_new_rounded),
      //         onTap: () {
      //           _launchUrl();
      //         },
      //       )
      //     : const SizedBox(),

      // notificationToggle(context),
      notificationToggleTile(),

      notificationBox(),

      ListTile(
        title: Text(
          'Logout',
          style: themeData.textTheme.bodyLarge,
        ),
        onTap: () async {
          bool logout = await showConformatoryLogoutDialog();

          if (logout) {
            // await performLogout();
            // // setState(() {
            // //   // isUserLoggedIn = false;
            // // });

            showLoadingDialog();

            await logoutRitual();

            if (mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            if (!mounted) return;
            Navigator.pushReplacement(this.context, PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
              return const LogoutIntermediatePage();
            }));
          }
        },
      ),

      const SizedBox(height: 10),

      AboutSection(
        appUrl: appURL,
        issueUrl: '$appURL/issues',
      )
    ]));
  }

  SwitchListTile notificationToggle(BuildContext context) {
    return SwitchListTile(
        value: areNotificationsEnabled && enabledNotificationSubscription,
        title: Text(
          'Notifications',
          style: themeData.textTheme.bodyLarge,
        ),
        subtitle: (areNotificationsEnabled && enabledNotificationSubscription)
            ? const Text(
                'You are subscribed to notifications. If you\'d like to silence them, please adjust your system settings.')
            : const Text('In alpha stage'),
        onChanged: (value) async {
          if (value) {
            await NotificationService().requestNotificationPermission();
            NotificationService().firebaseInit(context);
            await NotificationService().getFCMDeviceToken();

            if (loggedInAsSecurity) {
              await NotificationService().uploadSecurityDeviceToken();
              await NotificationService().subsribsibeSecurityToTopic();
            } else {
              await NotificationService().uploadDeviceToken();
              await NotificationService().subsribsibeUsersToTopic();
            }
          } else {
            await NotificationService().disableNotifications();
            if (loggedInAsSecurity) {
              await NotificationService().unsubscribeSecurityFromTopic();
            } else {
              await NotificationService().unsubscribeUsersFromTopic();
            }
            await NotificationService().checkNotificationPermission();
          }
          setState(() {});
        });
  }

  Widget notificationBox() {
    return (areNotificationsEnabled && enabledNotificationSubscription)
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // border: Border.all(color: themeData.colorScheme.secondary),
                  color: themeData.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 40,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'Notifications are off. Turn them on to receive updates. They won\'t drain your battery.',
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                )),
          );
  }

  ListTile notificationToggleTile() {
    return ListTile(
        title: Text(
          'Notifications',
          style: themeData.textTheme.bodyLarge,
        ),
        subtitle: (areNotificationsEnabled && enabledNotificationSubscription)
            ? const Text(
                'You are subscribed to notifications. If you\'d like to silence them, adjust your system settings.')
            : (Platform.isAndroid)
                ? null
                : const Text('Notifications for iOS are in development'),
        trailing: SizedBox(
            child: (isLoading)
                ? const SizedBox(
                    width: 60,
                    height: 50,
                    child: Center(child: CircularProgressIndicator()))
                : Switch(
                    value: areNotificationsEnabled &&
                        enabledNotificationSubscription,
                    onChanged: (Platform.isAndroid)
                        ? (value) async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              if (value) {
                                await NotificationService()
                                    .requestNotificationPermission();
                                NotificationService().firebaseInit(context);
                                await NotificationService().getFCMDeviceToken();

                                if (loggedInAsSecurity) {
                                  await NotificationService()
                                      .uploadSecurityDeviceToken();
                                  await NotificationService()
                                      .subsribsibeSecurityToTopic();
                                } else {
                                  await NotificationService()
                                      .uploadDeviceToken();
                                  await NotificationService()
                                      .subsribsibeUsersToTopic();
                                }
                              } else {
                                // await NotificationService().disableNotifications();
                                // if (loggedInAsSecurity) {
                                //   await NotificationService()
                                //       .unsubscribeSecurityFromTopic();
                                // } else {
                                //   await NotificationService()
                                //       .unsubscribeUsersFromTopic();
                                // }
                                await NotificationService()
                                    .completelyDisableNotifications();

                                await NotificationService()
                                    .checkNotificationPermission();
                              }
                            } catch (e) {
                              debugPrint('Error: $e');
                            }
                            setState(() {
                              isLoading = false;
                            });
                          }
                        : null)));
  }

  SwitchListTile devSwitchWid() {
    return SwitchListTile(
        value: useMyAccountAsSecurityAccount,
        title: Text(
          'Use my account as security account',
          style: themeData.textTheme.bodyLarge,
          // style: bodyMedium,
        ),
        subtitle: (useMyAccountAsSecurityAccount)
            ? const Text('Log out to switch')
            : null,
        onChanged: (value) {
          setState(() {
            useMyAccountAsSecurityAccount = value;
            (useMyAccountAsSecurityAccount)
                ? securityAccountEmail = loginID!
                : securityAccountEmail = 'securityoffice@iiti.ac.in';
          });
          debugPrint(
              'useMyAccountAsSecurityAccount: $useMyAccountAsSecurityAccount');
          debugPrint('securityAccountEmail: $securityAccountEmail');
        });
  }

  SingleChildScrollView appBarChangeButtonRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () {
                setState(() {
                  // requestUploadStatus = 'Normal';
                  requestUploadStatus.value = RequestUploadStatus.deleting;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.deleting;
                });
              },
              child: const Text('Deleting')),
          FilledButton(
              onPressed: () {
                setState(() {
                  // requestUploadStatus = 'Normal';
                  requestUploadStatus.value = RequestUploadStatus.deleted;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.deleted;
                });
              },
              child: const Text('Deleted')),
          FilledButton(
              onPressed: () {
                setState(() {
                  // requestUploadStatus = 'Normal';
                  requestUploadStatus.value = RequestUploadStatus.deleteError;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.deleteError;
                });
              },
              child: const Text('deleteError')),
          FilledButton(
              onPressed: () {
                setState(() {
                  // requestUploadStatus = 'Normal';
                  requestUploadStatus.value = RequestUploadStatus.normal;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.normal;
                });
              },
              child: const Text('Normal')),
          FilledButton(
              onPressed: () {
                setState(() {
                  requestUploadStatus.value = RequestUploadStatus.uploading;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.uploading;
                });
              },
              child: const Text('Uploading')),
          FilledButton(
              onPressed: () {
                setState(() {
                  requestUploadStatus.value = RequestUploadStatus.uploaded;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.uploaded;
                });
              },
              child: const Text('Uploaded')),
          FilledButton(
              onPressed: () {
                setState(() {
                  requestUploadStatus.value =
                      RequestUploadStatus.someThingWentWrong;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.someThingWentWrong;
                });
              },
              child: const Text('Something went wrong app bar')),
          FilledButton(
              onPressed: () {
                setState(() {
                  requestUploadStatus.value = RequestUploadStatus.uploadError;
                  securityRequestUploadStatus.value =
                      SecurityRequestUploadStatus.uploadError;
                });
              },
              child: const Text('uppload error app bar')),
        ],
      ),
    );
  }
}
