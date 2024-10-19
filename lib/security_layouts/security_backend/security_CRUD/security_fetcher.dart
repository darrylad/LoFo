import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lofo/main.dart';
import 'package:lofo/security_layouts/security_components/security_letter_card.dart';

class GetSecurityInbox extends StatefulWidget {
  const GetSecurityInbox({super.key});

  @override
  State<GetSecurityInbox> createState() => _GetSecurityInboxState();
}

class _GetSecurityInboxState extends State<GetSecurityInbox> {
  Stream<QuerySnapshot> getDocIdStream() {
    try {
      return FirebaseFirestore.instance
          .collection('privateRequests')
          .snapshots();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // List<Map<String, dynamic>> docIDs = [];
  // Future getDocId() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('privateRequests')
  //         .get()
  //         .then((snapshot) => snapshot.docs.forEach((element) {
  //               docIDs.add({
  //                 'id': element.reference.id,
  //                 'timestamp': element['postPostedAt'],
  //                 'data': element.data(),
  //               });
  //               debugPrint(docIDs.toString());
  //             }));
  //     docIDs.sort((a, b) {
  //       DateTime aDate = DateTime.parse(a['timestamp']);
  //       DateTime bDate = DateTime.parse(b['timestamp']);
  //       return bDate.compareTo(aDate);
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getDocIdStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<Map<String, dynamic>> docIDs = snapshot.data!.docs
                .map((doc) => {
                      'id': doc.reference.id,
                      'timestamp': doc['postPostedAt'],
                      'data': doc.data(),
                    })
                .toList();

            docIDs.sort((a, b) {
              DateTime aDate = DateTime.parse(a['timestamp']);
              DateTime bDate = DateTime.parse(b['timestamp']);
              return bDate.compareTo(aDate);
            });

            if (docIDs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_rounded,
                        size: 100, color: themeData.colorScheme.secondary),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('Nothing to show here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeData.colorScheme.secondary,
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return GetSecurityInboxDetails(
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
      cardHandedOverTo: data['postHandedOverTo'],
      cardName: data['postName'],
      cardImageURL: data['postImageURL'],
      userImageURL: data['userImageURL'],
      cardPostedAt: data['postPostedAt'],
      cardCategory: data['postCategory'],
      cardPosterID: data['postPosterID'],
      isArchived: data['isArchived'],
    );
  }
}

// ------------------------------ Home Posts ------------------------------

class GetSecurityHomePosts extends StatefulWidget {
  const GetSecurityHomePosts({super.key});

  @override
  State<GetSecurityHomePosts> createState() => _GetSecurityHomePostsState();
}

class _GetSecurityHomePostsState extends State<GetSecurityHomePosts> {
  Stream<QuerySnapshot> getDocIdStream() {
    try {
      return FirebaseFirestore.instance
          .collection('publicRequests')
          .snapshots();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // List<Map<String, dynamic>> docIDs = [];
  // Future getDocId() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('publicRequests')
  //         .get()
  //         .then((snapshot) => snapshot.docs.forEach((element) {
  //               docIDs.add({
  //                 'id': element.reference.id,
  //                 'timestamp': element['postPostedAt'],
  //                 'data': element.data(),
  //               });
  //               debugPrint(docIDs.toString());
  //             }));
  //     docIDs.sort((a, b) {
  //       DateTime aDate = DateTime.parse(a['timestamp']);
  //       DateTime bDate = DateTime.parse(b['timestamp']);
  //       return bDate.compareTo(aDate);
  //     });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getDocIdStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            List<Map<String, dynamic>> docIDs = snapshot.data!.docs
                .map((doc) => {
                      'id': doc.reference.id,
                      'timestamp': doc['postPostedAt'],
                      'data': doc.data(),
                    })
                .toList();

            docIDs.sort((a, b) {
              DateTime aDate = DateTime.parse(a['timestamp']);
              DateTime bDate = DateTime.parse(b['timestamp']);
              return bDate.compareTo(aDate);
            });

            if (docIDs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 100, color: themeData.colorScheme.secondary),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                          'Nothing to show here. Tap the floating + button to add a post.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeData.colorScheme.secondary,
                            fontSize: 20,
                          )),
                    ),
                  ],
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
      cardHandedOverTo: data['postHandedOverTo'],
      cardName: data['postName'],
      cardImageURL: data['postImageURL'],
      userImageURL: data['userImageURL'],
      cardPostedAt: data['postPostedAt'],
      cardCategory: data['postCategory'],
      cardPosterID: data['postPosterID'],
      isArchived: data['isArchived'],
    );
  }
}
