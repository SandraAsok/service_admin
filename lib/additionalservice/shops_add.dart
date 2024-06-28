import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Addshops extends StatefulWidget {
  final String category;
  const Addshops({super.key, required this.category});

  @override
  State<Addshops> createState() => _AddshopsState();
}

class _AddshopsState extends State<Addshops> {
  TextEditingController name = TextEditingController();
  TextEditingController owner = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController openingtime = TextEditingController();
  TextEditingController closingtime = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController phone = TextEditingController();

  String image = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final pickedfile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedfile == null) {
                      return;
                    } else {
                      File file = File(pickedfile.path);
                      image = await uploadimage(file);
                      setState(() async {});
                    }
                  },
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 2.0),
                      ),
                      child: const Center(
                        child: Text("pick image"),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Shop name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: owner,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'owner name',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: rating,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Rating',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: openingtime,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'opening time',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: closingtime,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'closing time',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'location',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: phone,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Enquiry number',
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('shops').add({
                        'owner': owner.text,
                        'shop_name': name.text,
                        'category': widget.category,
                        'image': image,
                        'rating': rating.text,
                        'opening': openingtime.text,
                        'closing': closingtime.text,
                        'location': location.text,
                        'phone': phone.text,
                      });
                      owner.clear();
                      name.clear();
                      rating.clear();
                      openingtime.clear();
                      closingtime.clear();
                      location.clear();
                      phone.clear();
                      image = "";
                    },
                    child: const Text("Add")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadimage(File file) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String timestamp = now.millisecondsSinceEpoch.toString();
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
