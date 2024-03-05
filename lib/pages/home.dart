// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lofo/backend/home_letter_card_list_example.dart';

import 'package:lofo/components/letter_card.dart';
import 'package:lofo/components/new_post_floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar('Home', userImageExample),
      body: ListView.builder(
          itemCount: database1.length,
          itemBuilder: (context, index) {
            return LetterCard(
              cardTitle: database1[index].cardTitle,
              cardDescription: database1[index].cardDescription,
              cardLocation: database1[index].cardLocation,
              cardLeftBehindAt: database1[index].cardLeftBehindAt,
              cardName: database1[index].cardName,
              cardImage: database1[index].cardImage,
              userImage: database1[index].userImage,
            );
          }),
      floatingActionButton: NewPostFloatingActionButton(fabKey: _fabKey),
    );
  }
}
