// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('bookings')
              .orderBy('booked_date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text('${data['job']} -client -  ${data['name']}'),
                    subtitle: Column(
                      children: [
                        Text(data['labour_name']),
                        Text(data['booked_date']),
                        IconButton(
                            onPressed: () async {
                              try {
                                String phone = data['labour_phone'];
                                String message =
                                    "Your ${data['job']} - ${data['details']}\n service booking has been done \n Booking Details: labour name : ${data['labour_name']} \n Booked Date: ${data['booked_date']} \n Working Hours: ${data['hours']} \n For any queries contact the labour : ${data['labour_phone']} \n - A2Z Service";
                                final url = Uri(
                                  scheme: 'sms',
                                  path: phone,
                                  queryParameters: {'body': message},
                                );
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(Icons.sms)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton.icon(
                                style: ButtonStyle(
                                    fixedSize: MaterialStatePropertyAll(
                                        Size(200, 20))),
                                icon: Icon(Icons.call),
                                onPressed: () {},
                                label: Text(data['labour_name'])),
                            ElevatedButton(
                                onPressed: () {}, child: Text('Inform client')),
                          ],
                        ),
                        data['status'] == "pending"
                            ? MaterialButton(
                                color: Colors.redAccent,
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(data.id)
                                      .update({'status': 'assigned'});
                                  setState(() {});
                                },
                                child: Text("Job Assigned ?"))
                            : MaterialButton(
                                color: Colors.greenAccent,
                                onPressed: () {},
                                child: Text("Assigned")),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
