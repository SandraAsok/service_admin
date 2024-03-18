import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_admin/lists.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddLaboursForm extends StatefulWidget {
  const AddLaboursForm({Key? key});

  @override
  State<AddLaboursForm> createState() => _AddLaboursFormState();
}

String? jobvalue;
TextEditingController name = TextEditingController();
TextEditingController age = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController details = TextEditingController();

class _AddLaboursFormState extends State<AddLaboursForm> {
  List<String> imageList = [];

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

                    setState(() async {
                      imageList = await uploadImage(file);
                    });
                  }
                },
                child: SizedBox(
                  height: size.height * 0.5,
                  width: size.width * 0.6,
                  child: imageList.isEmpty
                      ? Container(
                          height: size.height * 0.4,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 2.0)),
                          child: const Center(
                            child: Text(
                              "Pick Image",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        )
                      : Image.network(imageList[0]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: name,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Labour name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: age,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Labour age',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: phone,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: address,
                maxLines: 5,
                decoration: const InputDecoration(
                  icon: Icon(Icons.home),
                  labelText: 'Address With Pincode',
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              iconSize: 25,
              dropdownColor: Colors.purple,
              hint: const Text("Job Type"),
              value: jobvalue,
              items: jobs.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newvalue) {
                setState(() {
                  jobvalue = newvalue;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: details,
                maxLines: 5,
                decoration: const InputDecoration(
                  icon: Icon(Icons.details),
                  labelText: 'Details',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  addlabour();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                ),
                child: const Text(
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

  Future<List<String>> uploadImage(File file) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    DateTime now = DateTime.now();
    String timestamp = now.millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = storage.ref().child('images/$timestamp');
    firebase_storage.UploadTask task = ref.putFile(file);
    await task;
    String downloadURL = await ref.getDownloadURL();
    imageList.add(downloadURL);
    return imageList;
  }

  Future<void> addlabour() async {
    try {
      await FirebaseFirestore.instance.collection('labours').add({
        'image': imageList,
        'name': name.text,
        'age': age.text,
        'phone': phone.text,
        'address': address.text,
        'job': jobvalue,
        'details': details.text,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
