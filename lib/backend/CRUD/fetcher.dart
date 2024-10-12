import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lofo/backend/login_details.dart';
import 'package:lofo/components/letter_card.dart';
import 'package:lofo/main.dart';

class GetYourPosts extends StatefulWidget {
  const GetYourPosts({super.key});

  @override
  State<GetYourPosts> createState() => _GetYourPostsState();
}

class _GetYourPostsState extends State<GetYourPosts> {
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
  //               if (element['postPosterID'] == loginID) {
  //                 docIDs.add({
  //                   'id': element.reference.id,
  //                   'timestamp': element['postPostedAt'],
  //                   'data': element.data(),
  //                 });
  //                 debugPrint(docIDs.toString());
  //               }
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
                .where((doc) => doc['postPosterID'] == loginID)
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
              return nothingToShowHerePage();
            } else {
              return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return YourPostsDetails(
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

  Center nothingToShowHerePage() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_circle_rounded,
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
  }
}

class YourPostsDetails extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> data;

  const YourPostsDetails({
    super.key,
    required this.docID,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // CollectionReference privateRequests =
    // FirebaseFirestore.instance.collection('privateRequests');
    // return FutureBuilder<DocumentSnapshot>(
    //   future: privateRequests.doc(docID).get(),
    //   builder: ((context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data =
    //           snapshot.data!.data() as Map<String, dynamic>;

    return LetterCard(
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
    );

    // return StreamBuilder(
    //   stream: privateRequests.doc(docID).snapshots(),
    //   builder: ((context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.active) {
    //       var data = snapshot.data;
    //       return Text(data['postTitle']);
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   }),
    // );
    // } else {
    //   return const LetterCard(
    //       cardTitle: 'Loading...',
    //       cardID: 'Loading...',
    //       cardDescription: 'Loading...',
    //       cardLocation: 'Loading...',
    //       cardTimeLastSeen: 'Loading...',
    //       cardName: 'Loading...',
    //       cardImageURL: null,
    //       userImageURL: 'https://picsum.photos/250?image=9',
    //       cardPostedAt: '0000-00-00 00:00:00.000',
    //       cardCategory: 2);
    // }
    //   }),
    // );
  }
}

// ------------------------------ Home Posts ------------------------------

class GetHomePosts extends StatefulWidget {
  const GetHomePosts({super.key});

  @override
  State<GetHomePosts> createState() => _GetHomePostsState();
}

class _GetHomePostsState extends State<GetHomePosts> {
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
                    return GetHomePostsDetails(
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

class GetHomePostsDetails extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> data;

  const GetHomePostsDetails({
    super.key,
    required this.docID,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LetterCard(
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
    );
  }
}
