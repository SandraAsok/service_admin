// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddLaboursForm extends StatefulWidget {
  final String service;
  const AddLaboursForm({super.key, required this.service});

  @override
  State<AddLaboursForm> createState() => _AddLaboursFormState();
}

// String? jobvalue;
TextEditingController name = TextEditingController();
TextEditingController age = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController details = TextEditingController();

class _AddLaboursFormState extends State<AddLaboursForm> {
  String image = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Labour's Form",
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
                onTap: () async {
                  final pickedfile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedfile == null) {
                    return;
                  } else {
                    File file = File(pickedfile.path);
                    image = await uploadImage(file);
                    setState(() async {});
                  }
                },
                child: SizedBox(
                  height: size.height * 0.5,
                  width: size.width * 0.6,
                  child: image == ""
                      ? Container(
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 2.0)),
                          child: Center(
                            child: Text(
                              "Pick Image",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        )
                      : Image.network(image),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Service: ${widget.service}",
                  style: TextStyle(fontSize: 18),
                )),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Labour name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: age,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Labour age',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: phone,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone number',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: address,
                maxLines: 5,
                decoration: InputDecoration(
                  icon: Icon(Icons.home),
                  labelText: 'Address With Pincode',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: details,
                maxLines: 5,
                decoration: InputDecoration(
                  icon: Icon(Icons.details),
                  labelText: 'Details',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  addlabour();
                  name.clear();
                  age.clear();
                  phone.clear();
                  address.clear();
                  details.clear();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage(File file) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String timestamp = now.millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = storage.ref().child('images/$timestamp');
    firebase_storage.UploadTask task = ref.putFile(file);
    await task;
    String downloadURL = await ref.getDownloadURL();
    setState(() {
      image = downloadURL;
    });
    return image;
  }

  Future<void> addlabour() async {
    try {
      await FirebaseFirestore.instance.collection('labours').add({
        'image': image,
        'name': name.text,
        'age': age.text,
        'phone': phone.text,
        'address': address.text,
        'job': widget.service,
        'details': details.text,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
