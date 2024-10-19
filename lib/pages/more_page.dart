import 'package:flutter/material.dart';
import 'package:lofo/animation/logout_intermediate.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';
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

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
        // appBar: appBar('Hi, Darryl', userImageExample),
        body: ListView(children: [
      // const SizedBox(height: 20),
      // appBarChangeButtonRow(),
      const SizedBox(height: 20),
      Hero(
        tag: 'about',
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            title: Text('About', style: themeData.textTheme.bodyLarge),
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AboutPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ));
            },
          ),
        ),
      ),

      // (devSwitch) ? devSwitchWid() : const SizedBox(),

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
      (appURL != 'null')
          ? ListTile(
              title: Text(
                'View source code',
                style: themeData.textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.open_in_new_rounded),
              onTap: () {
                _launchUrl();
              },
            )
          : const SizedBox(),

      // notificationToggle(context),
      notificationToggleTile(),

      notificationBox(),

      ListTile(
        title: Text(
          'Logout and delete account',
          style: themeData.textTheme.bodyLarge,
        ),
        onTap: () async {
          await performLogout();
          // setState(() {
          //   // isUserLoggedIn = false;
          // });
          if (!mounted) return;
          Navigator.pushReplacement(this.context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const LogoutIntermediatePage();
          }));
        },
      ),

      const SizedBox(height: 200),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Notifications are off. Turn them on to receive updates.  We use push notifications, that do not drain your battery.',
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
                'You are subscribed to notifications. If you\'d like to silence them, you can do that in your system settings.')
            : const Text('In alpha stage'),
        trailing: SizedBox(
            width: 50,
            height: 50,
            child: (isLoading)
                ? const Center(child: CircularProgressIndicator())
                : Switch(
                    value: areNotificationsEnabled &&
                        enabledNotificationSubscription,
                    onChanged: (value) async {
                      setState(() {
                        isLoading = true;
                      });
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
                          await NotificationService().uploadDeviceToken();
                          await NotificationService().subsribsibeUsersToTopic();
                        }
                      } else {
                        await NotificationService().disableNotifications();
                        if (loggedInAsSecurity) {
                          await NotificationService()
                              .unsubscribeSecurityFromTopic();
                        } else {
                          await NotificationService()
                              .unsubscribeUsersFromTopic();
                        }
                        await NotificationService()
                            .checkNotificationPermission();
                      }
                      setState(() {
                        isLoading = false;
                      });
                    })));
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
