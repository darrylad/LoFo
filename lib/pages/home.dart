import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/fetcher.dart';
import 'package:lofo/components/npost_fab.dart';

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
      // body: ListView.builder(
      //     itemCount: database1.length,
      //     itemBuilder: (context, index) {
      //       return LetterCard(
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
      body: const GetHomePosts(),

      floatingActionButton: NPostFAB(
        fabKey: _fabKey,
      ),

      // floatingActionButton:
      //     DepricatedNewPostFloatingActionButton(fabKey: _fabKey),
    );
  }
}
