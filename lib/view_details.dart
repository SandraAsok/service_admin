// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    String id = args['id'];
    String name = args['name'];
    String age = args['age'];
    String phone = args['phone'];
    String address = args['address'];
    String details = args['details'];
    String image = args['image'];
    String jobvalue = args['job'];

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Labour's Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.6,
                    child: Container(
                      height: size.height * 0.4,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2.0),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(image))),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Name : $name"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Age : $age"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Phone : $phone"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Address : $address"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Details : $details"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Job Category : $jobvalue"),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Total Bookings : "),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("Feedbacks :"),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('feedback')
                    .where('job', isEqualTo: jobvalue)
                    .where('labour_name', isEqualTo: name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    log(snapshot.error.toString());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final document = snapshot.data!.docs[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text(
                                document['userID'],
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 10),
                              Text(
                                document['review'],
                                style: TextStyle(fontSize: 18),
                              ),
                              Divider(),
                            ],
                          ));
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
