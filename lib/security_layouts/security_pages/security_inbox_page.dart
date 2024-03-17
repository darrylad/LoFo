import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_backend/security_CRUD/security_fetcher.dart';

class SecurityInboxPage extends StatefulWidget {
  const SecurityInboxPage({super.key});

  @override
  State<SecurityInboxPage> createState() => _SecurityInboxPageState();
}

class _SecurityInboxPageState extends State<SecurityInboxPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body:
      // ListView.builder(
      //     itemCount: databaseSecurityInbox.length,
      //     itemBuilder: (context, index) {
      //       return SecurityLetterCard(
      //           cardType: 1,
      //           cardCategory: databaseSecurityInbox[index].cardCategory,
      //           cardTitle: databaseSecurityInbox[index].cardTitle,
      //           cardID: databaseSecurityInbox[index].cardID,
      //           cardDescription: databaseSecurityInbox[index].cardDescription,
      //           cardLocation: databaseSecurityInbox[index].cardLocation,
      //           cardTimeLastSeen: databaseSecurityInbox[index].cardTimeLastSeen,
      //           cardName: databaseSecurityInbox[index].cardName,
      //           cardImageURL: databaseSecurityInbox[index].cardImageURL,
      //           userImageURL: databaseSecurityInbox[index].userImageURL!,
      //           cardPostedAt: databaseSecurityInbox[index].cardPostedAt);
      //     }),
      body: GetSecurityInbox(),
    );
  }
}
