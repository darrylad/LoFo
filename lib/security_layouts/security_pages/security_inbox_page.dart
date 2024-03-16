import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_backend/security_inbox_example_database.dart';
import 'package:lofo/security_layouts/security_components/security_letter_card.dart';

class SecurityInboxPage extends StatefulWidget {
  const SecurityInboxPage({super.key});

  @override
  State<SecurityInboxPage> createState() => _SecurityInboxPageState();
}

class _SecurityInboxPageState extends State<SecurityInboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: databaseSecurityInbox.length,
          itemBuilder: (context, index) {
            return SecurityLetterCard(
                cardType: 1,
                cardCategory: databaseSecurityInbox[index].cardCategory,
                cardTitle: databaseSecurityInbox[index].cardTitle,
                cardID: databaseSecurityInbox[index].cardID,
                cardDescription: databaseSecurityInbox[index].cardDescription,
                cardLocation: databaseSecurityInbox[index].cardLocation,
                cardTimeLastSeen: databaseSecurityInbox[index].cardTimeLastSeen,
                cardName: databaseSecurityInbox[index].cardName,
                cardImage: databaseSecurityInbox[index].cardImage,
                userImage: databaseSecurityInbox[index].userImage!,
                cardPostedAt: databaseSecurityInbox[index].cardPostedAt);
          }),
    );
  }
}
