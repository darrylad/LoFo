import 'package:flutter/material.dart';
import 'package:lofo/animation/logout_intermediate.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/app_bar.dart';
import 'package:lofo/theme/light_theme.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: appBar('Hi, Darryl', userImageExample),
        body: ListView(children: [
      // const SizedBox(height: 20),
      // appBarChangeButtonRow(),
      // const SizedBox(height: 20),
      Hero(
        tag: 'about',
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            title: Text('About', style: bodyMedium),
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
      ListTile(
        title: Text(
          'Log Out',
          style: bodyMedium,
        ),
        onTap: () async {
          performLogout(context);
          // setState(() {
          //   // isUserLoggedIn = false;
          // });
          Navigator.pushReplacement(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
            return const LogoutIntermediatePage();
          }));
        },
      ),
      const SizedBox(height: 200),
    ]));
  }

  Row appBarChangeButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              setState(() {
                // requestUploadStatus = 'Normal';
                requestUploadStatus.value = 'Normal';
              });
            },
            child: const Text('Normal')),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              setState(() {
                requestUploadStatus.value = 'Uploading';
              });
            },
            child: const Text('Uploading')),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              setState(() {
                requestUploadStatus.value = 'Uploaded';
              });
            },
            child: const Text('Uploaded')),
        const SizedBox(height: 20),
      ],
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget leading = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    return Hero(
      tag: 'about',
      child: Scaffold(
          appBar: appBar('About', null, leading: leading),
          body: Opacity(
              opacity: 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/madeWIthLoveTextPNG.png',
                      width: 220,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/gdsclogo.png',
                      width: 120,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ],
              ))),
    );
  }
}
