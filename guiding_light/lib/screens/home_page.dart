import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class UserHomePage extends StatefulWidget {
  static const String routeName = '/home-screen';
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _UserHomePageState extends State<UserHomePage> {
  Map<String, bool> cardExpandedMap = {};

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(documentId)
        .delete();
  }

  bool shouldShowMore(String text, TextStyle style, int maxLines) {
    final span = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('therapists given posts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String title = data['title'] ?? 'No Subject';

              //String week = data['week'] ?? 'No week';

              String expandedText = data['post'] ?? 'No post';

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.person_2, // Replace with the desired icon
                            color: Color.fromRGBO(
                                7, 7, 3, 1), // Change the icon color as needed
                          ),
                          const SizedBox(
                              width:
                                  8.0), // Add some spacing between the icon and text
                          Text(
                            ' $title', // Replace with your desired title
                            style: const TextStyle(
                              fontSize: 18.0, // Adjust the font size as needed
                              fontWeight: FontWeight
                                  .bold, // You can change the font weight
                            ),
                          ),
                        ],
                      ),
                      subtitle: ReadMoreText(
                        expandedText,
                        trimLines: 3,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Show More ",
                        trimExpandedText: " Show Less ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
