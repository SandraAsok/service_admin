
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/labourslist.dart';
import 'package:service_admin/services/add_service.dart';

class Services extends StatefulWidget {
  const Services({
    super.key,
  });

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  String image = "";
  TextEditingController newservice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('services').snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LaboursList(
                                  service: document['service'],
                                ),
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(document['cover']),
                              ),
                              Text(document['service']),
                            ],
                          )),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddService(),
                  ));
            },
            label: Text("Add New Service")),
      ),
    );
  }
}
