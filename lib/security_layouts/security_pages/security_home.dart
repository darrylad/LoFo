import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_fetcher.dart';
import 'package:lofo/security_layouts/security_components/security_new_post_floating_action_button.dart';

class SecurityHomePage extends StatefulWidget {
  const SecurityHomePage({super.key});

  @override
  State<SecurityHomePage> createState() => _SecurityHomePageState();
}

class _SecurityHomePageState extends State<SecurityHomePage> {
  final GlobalKey _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar('Home', userImageExample),
      // body: ListView.builder(
      //     itemCount: database1.length,
      //     itemBuilder: (context, index) {
      //       return SecurityLetterCard(
      //         cardType: 0,
      //         cardCategory: database1[index].cardCategory,
      //         cardTitle: database1[index].cardTitle,
      //         cardID: database1[index].cardID,
      //         cardPostedAt: database1[index].cardPostedAt,
      //         cardDescription: database1[index].cardDescription,
      //         cardLocation: database1[index].cardLocation,
      //         cardTimeLastSeen: database1[index].cardTimeLastSeen,
      //         cardName: database1[index].cardName,
      //         cardImageURL: database1[index].cardImageURL,
      //         userImageURL: database1[index].userImageURL!,
      //       );
      //     }),
      body: const GetSecurityHomePosts(),
      floatingActionButton:
          SecurityNewPostFloatingActionButton(fabKey: _fabKey),
    );
  }
}
