import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/fetcher.dart';
import 'package:lofo/components/npost_fab.dart';
// import 'package:lofo/components/app_bar.dart';

class YourPostsPage extends StatefulWidget {
  const YourPostsPage({super.key});

  @override
  State<YourPostsPage> createState() => _YourPostsPageState();
}

class _YourPostsPageState extends State<YourPostsPage> {
  final GlobalKey _fabKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar('Your Requests', userImageExample),
      body: const Center(
        child: GetYourPosts(),
      ),
      // floatingActionButton:
      //     DepricatedNewPostFloatingActionButton(fabKey: _fabKey),
      floatingActionButton: NPostFAB(fabKey: _fabKey),
    );
  }
}
