// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditLaboursForm extends StatefulWidget {
  const EditLaboursForm({super.key});

  @override
  State<EditLaboursForm> createState() => _EditLaboursFormState();
}

class _EditLaboursFormState extends State<EditLaboursForm> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController details = TextEditingController();
  String image = "";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    String id = args['id'];
    name.text = args['name'];
    age.text = args['age'];
    phone.text = args['phone'];
    address.text = args['address'];
    details.text = args['details'];
    String image = args['image'];
    String jobvalue = args['job'];

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Labour's Editing Form",
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
                                  Border.all(color: Colors.purple, width: 2.0),
                              image:
                                  DecorationImage(image: NetworkImage(image))),
                        )
                      : Image.network(image),
                ),
              ),
            ),
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
              child: Text(jobvalue),
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
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('labours')
                      .doc(id)
                      .update({
                    'image': image,
                    'name': name.text,
                    'age': age.text,
                    'phone': phone.text,
                    'address': address.text,
                    'job': jobvalue,
                    'details': details.text,
                  });
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
}
