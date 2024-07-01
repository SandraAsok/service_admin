import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_admin/additionalservice/shops.dart';
import 'package:service_admin/labourslist.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdditionalServices extends StatefulWidget {
  const AdditionalServices({super.key});

  @override
  State<AdditionalServices> createState() => _AdditionalServicesState();
}

class _AdditionalServicesState extends State<AdditionalServices> {
  String image = "";
  List<String> option = [
    "shop",
    "labour",
  ];
  String? optionvalue;
  TextEditingController newservice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('additionalservices')
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final document = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          if (document['option'] == 'shop') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Shops(
                                    category: document['service'],
                                  ),
                                ));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LaboursList(
                                    service: document['service'],
                                  ),
                                ));
                          }
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
                  title: const Text("Add new service"),
                  content: SizedBox(
                    height: 250,
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
                              : const CircleAvatar(
                                  radius: 50,
                                  child: Text("Add image"),
                                ),
                        ),
                        TextField(
                          controller: newservice,
                          decoration: const InputDecoration(
                              hintText: "enter new service"),
                        ),
                        SizedBox(height: 10),
                        DropdownButton(
                          elevation: 0,
                          hint: Text("Select service Option"),
                          value: optionvalue,
                          onChanged: (value) {
                            setState(() {
                              optionvalue = value;
                            });
                          },
                          items: option.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("cancel")),
                    TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection("additionalservices")
                              .add({
                            'cover': image,
                            'service': newservice.text,
                            'option': optionvalue,
                          });
                          image = "";
                          newservice.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Add")),
                  ],
                ),
              );
            },
            label: const Text("Add New Service")),
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
