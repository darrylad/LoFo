import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lofo/security_layouts/security_components/security_letter_card.dart';

class GetSecurityInbox extends StatefulWidget {
  const GetSecurityInbox({super.key});

  @override
  State<GetSecurityInbox> createState() => _GetSecurityInboxState();
}

class _GetSecurityInboxState extends State<GetSecurityInbox> {
  List<Map<String, dynamic>> docIDs = [];
  Future getDocId() async {
    try {
      await FirebaseFirestore.instance
          .collection('privateRequests')
          .get()
          .then((snapshot) => snapshot.docs.forEach((element) {
                docIDs.add({
                  'id': element.reference.id,
                  'timestamp': element['postPostedAt'],
                  'data': element.data(),
                });
                debugPrint(docIDs.toString());
              }));
      docIDs.sort((a, b) {
        DateTime aDate = DateTime.parse(a['timestamp']);
        DateTime bDate = DateTime.parse(b['timestamp']);
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return GetSecurityInboxDetails(
                    // docID: docIDs[index],
                    docID: docIDs[index]['id'],
                    data: docIDs[index]['data'],
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class GetSecurityInboxDetails extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> data;

  const GetSecurityInboxDetails(
      {super.key, required this.docID, required this.data});

  @override
  Widget build(BuildContext context) {
    return SecurityLetterCard(
        cardType: 1,
        cardTitle: data['postTitle'],
        cardID: data['postID'],
        cardDescription: data['postDescription'],
        cardLocation: data['postLocation'],
        cardTimeLastSeen: data['postTimeLastSeen'],
        cardName: data['postName'],
        cardImageURL: data['postImageURL'],
        userImageURL: data['userImageURL'],
        cardPostedAt: data['postPostedAt'],
        cardCategory: data['postCategory']);
  }
}

// ------------------------------ Home Posts ------------------------------

class GetSecurityHomePosts extends StatefulWidget {
  const GetSecurityHomePosts({super.key});

  @override
  State<GetSecurityHomePosts> createState() => _GetSecurityHomePostsState();
}

class _GetSecurityHomePostsState extends State<GetSecurityHomePosts> {
  List<Map<String, dynamic>> docIDs = [];

  Future getDocId() async {
    try {
      await FirebaseFirestore.instance
          .collection('publicRequests')
          .get()
          .then((snapshot) => snapshot.docs.forEach((element) {
                docIDs.add({
                  'id': element.reference.id,
                  'timestamp': element['postPostedAt'],
                  'data': element.data(),
                });
                debugPrint(docIDs.toString());
              }));
      docIDs.sort((a, b) {
        DateTime aDate = DateTime.parse(a['timestamp']);
        DateTime bDate = DateTime.parse(b['timestamp']);
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDocId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (docIDs.isEmpty) {
              return const Center(
                child: Text(
                  'No Posts',
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return GetSecurityHomePostsDetails(
                      // docID: docIDs[index],
                      docID: docIDs[index]['id'],
                      data: docIDs[index]['data'],
                    );
                  });
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class GetSecurityHomePostsDetails extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> data;
  const GetSecurityHomePostsDetails(
      {super.key, required this.docID, required this.data});

  @override
  Widget build(BuildContext context) {
    return SecurityLetterCard(
        cardType: 0,
        cardTitle: data['postTitle'],
        cardID: data['postID'],
        cardDescription: data['postDescription'],
        cardLocation: data['postLocation'],
        cardTimeLastSeen: data['postTimeLastSeen'],
        cardName: data['postName'],
        cardImageURL: data['postImageURL'],
        userImageURL: data['userImageURL'],
        cardPostedAt: data['postPostedAt'],
        cardCategory: data['postCategory']);
  }
}
