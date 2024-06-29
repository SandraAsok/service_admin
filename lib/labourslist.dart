// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/add_labours_form.dart';

class LaboursList extends StatelessWidget {
  final String service;
  const LaboursList({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddLaboursForm(
                        service: service,
                      ),
                    ));
              },
              label: Text("Add labour")),
          body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('labours')
                  .where('job', isEqualTo: service)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      return Padding(
                          padding: EdgeInsets.all(20.0),
                          child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(data['image']),
                              ),
                              title: Text(data['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['job']),
                                  ElevatedButton.icon(
                                      icon: Icon(Icons.call),
                                      onPressed: () {},
                                      label: Text(data['phone'])),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      onTap: () {
                                        Navigator.pushNamed(context, 'view',
                                            arguments: {
                                              'id': data.id,
                                              'image': data['image'],
                                              'name': data['name'],
                                              'age': data['age'],
                                              'job': data['job'],
                                              'address': data['address'],
                                              'details': data['details'],
                                              'phone': data['phone'],
                                            });
                                      },
                                      child: Text("View Details")),
                                  PopupMenuItem(
                                      onTap: () => Navigator.pushNamed(
                                              context, 'edit',
                                              arguments: {
                                                'id': data.id,
                                                'image': data['image'],
                                                'name': data['name'],
                                                'age': data['age'],
                                                'job': data['job'],
                                                'address': data['address'],
                                                'details': data['details'],
                                                'phone': data['phone'],
                                              }),
                                      child: Text('Edit Details')),
                                  PopupMenuItem(
                                      onTap: () => showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text("Are you sure?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("cancel")),
                                                TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('labours')
                                                          .doc(data.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Yes"))
                                              ],
                                            ),
                                          ),
                                      child: Text('Delete'))
                                ],
                              )));
                    },
                  );
                } else if (snapshot.hasError) {
                  log(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
