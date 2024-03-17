import 'package:flutter/material.dart';
import 'package:lofo/backend/CRUD/fetcher.dart';
// import 'package:lofo/components/app_bar.dart';

class YourPostsPage extends StatefulWidget {
  const YourPostsPage({super.key});

  @override
  State<YourPostsPage> createState() => _YourPostsPageState();
}

class _YourPostsPageState extends State<YourPostsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: appBar('Your Requests', userImageExample),
      body: Center(
        child: GetYourPosts(),
      ),
    );
  }
}
