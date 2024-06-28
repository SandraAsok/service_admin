import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_admin/labourslist.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Add new service"),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final pickedfile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedfile == null) {
                              return;
                            } else {
                              File file = File(pickedfile.path);
                              image = await _uploadimage(file);
                              setState(() {});
                            }
                          },
                          child: image != ""
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(image),
                                )
                              : CircleAvatar(
                                  radius: 50,
                                  child: Text("Add image"),
                                ),
                        ),
                        TextField(
                          controller: newservice,
                          decoration:
                              InputDecoration(hintText: "enter new service"),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("cancel")),
                    TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("services")
                              .add({
                            'cover': image,
                            'service': newservice.text,
                          });
                          image = "";
                          newservice.clear();
                          Navigator.pop(context);
                        },
                        child: Text("Add")),
                  ],
                ),
              );
            },
            label: Text("Add New Service")),
      ),
    );
  }

  Future<String> _uploadimage(File file) async {
    final firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String timestamp = now.microsecondsSinceEpoch.toString();
    firebase_storage.Reference reference =
        storage.ref().child('images/$timestamp');
    firebase_storage.UploadTask task = reference.putFile(file);
    await task;
    String downloadurl = await reference.getDownloadURL();
    setState(() {
      image = downloadurl;
    });
    return image;
  }
}