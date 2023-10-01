import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class AdminHomePage extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _AdminHomePageState extends State<AdminHomePage> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current screen and go back to the previous screen.
          },
        ),
        title: const Text('therapists given posts'),
      ),
      floatingActionButton: SizedBox(
        child: FloatingActionButton(
          onPressed: () {
            showUploadDialog(context);
          },
          child: const Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.add),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                ),
              ),
            ],
          ),
        ),
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
                        style: const TextStyle(
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

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = '';

      String? post;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Submit the therapy post'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: workflowController,
                      onChanged: (value) {
                        post = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'therapy post ',
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "close",
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Perform the upload to Firestore using the provided data
                  // You can implement your logic here

                  // Upload the PDF file to Firestore using the `path` variable
                  // You can implement your upload logic here

                  if (title.isEmpty || post == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('posts');
                  DocumentReference newDocument = documentsCollection.doc();

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)

                  // Create a new document with the provided data
                  await newDocument.set({
                    'title': title,
                    'post': post,
                  });
                  setState(() {
                    titleController.clear();
                    workflowController.clear();
                  });
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('post Upload'),
                        content: const Text(
                            'The post has been uploaded successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // Close the dialog
                  //Navigator.of(context).pop();
                },
                child: const Text('save post'),
              ),
            ],
          );
        },
      );
    },
  );
}
