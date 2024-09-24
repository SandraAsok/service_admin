import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String image = "";
  TextEditingController newservice = TextEditingController();
  TextEditingController subservice = TextEditingController();
  TextEditingController subprice = TextEditingController();

  List<String> subservicelist = [];
  List<int> subpricelist = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
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
                          radius: 60,
                          backgroundImage: NetworkImage(image),
                        )
                      : const CircleAvatar(
                          radius: 60,
                          child: Text("Add image"),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: newservice,
                  decoration:
                      const InputDecoration(hintText: "enter new service"),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Add Sub Services"),
                        content: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                controller: subservice,
                                decoration: const InputDecoration(
                                    labelText: 'Sub service name'),
                              ),
                              TextField(
                                controller: subprice,
                                decoration: const InputDecoration(
                                    labelText: 'Sub service price'),
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
                              onPressed: () {
                                setState(() {
                                  subservicelist.add(subservice.text);
                                  subpricelist.add(int.parse(subprice.text));
                                });
                                subprice.clear();
                                subservice.clear();
                                Navigator.pop(context);
                              },
                              child: const Text("Add")),
                        ],
                      ),
                    );
                  },
                  child: subservicelist.isEmpty && subpricelist.isEmpty
                      ? const Text("Add new sub service")
                      : const Text("Add More")),
              Row(
                children: [
                  SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: subservicelist.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(subservicelist[index]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width / 2,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: subpricelist.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(":  ${subpricelist[index].toString()}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              subpricelist.removeAt(index);
                              subservicelist.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        bottomSheet: ElevatedButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('services').add({
              'cover': image,
              'service': newservice.text,
              'subservices': subservicelist,
              'subservice_price': subpricelist,
            });
            image = "";
            newservice.clear();
            subservicelist.clear();
            subpricelist.clear();
            Navigator.pop(context);
          },
          child: Text(
            "Submit",
            style: TextStyle(fontSize: 20),
          ),
        ),
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
