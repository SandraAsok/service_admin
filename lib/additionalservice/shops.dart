// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/additionalservice/shops_add.dart';

class Shops extends StatefulWidget {
  final String category;
  const Shops({super.key, required this.category});

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('shops')
              .where('category', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final document = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple)),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 150,
                          width: 120,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(document['image']))),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Text(
                              document['shop_name'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("⭐ ${document['rating']}"),
                            Text(
                                "${document['opening']} to ${document['closing']}",
                                style: TextStyle(fontSize: 15)),
                            Text(document['location']),
                            SizedBox(height: 10),
                            Text("Owner : ${document['owner']}"),
                            ElevatedButton.icon(
                              onPressed: () {
                                final phone = document['phone'];
                              },
                              icon: Icon(Icons.call),
                              label: Text("Enquiry"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Addshops(
                      category: widget.category,
                    ),
                  ));
            },
            label: Text("Add Shops")),
      ),
    );
  }
}
