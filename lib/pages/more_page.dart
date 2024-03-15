import 'package:flutter/material.dart';
import 'package:lofo/animation/logout_intermediate.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/login_verification.dart';
import 'package:lofo/main.dart';
import 'package:lofo/pages/about_page.dart';
import 'package:lofo/security_layouts/security_components/security_app_bar.dart';

bool useMyAccountAsSecurityAccount = false;

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
        // appBar: appBar('Hi, Darryl', userImageExample),
        body: ListView(children: [
      const SizedBox(height: 20),
      appBarChangeButtonRow(),
      const SizedBox(height: 20),
      Hero(
        tag: 'about',
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            title: Text('About', style: themeData.textTheme.bodyMedium),
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
      SwitchListTile(
          value: useMyAccountAsSecurityAccount,
          title: Text(
            'Use my account as security account',
            style: themeData.textTheme.bodyMedium,
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
          }),
      ListTile(
        title: Text(
          'Log Out',
          style: themeData.textTheme.bodyMedium,
        ),
        onTap: () async {
          await performLogout(context);
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
