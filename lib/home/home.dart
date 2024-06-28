// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:service_admin/additionalservice/additional.dart';
import 'package:service_admin/bookings.dart';
import 'package:service_admin/services/services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Admin Panel",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Services(),
                    ));
              },
              child: Text("Services")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdditionalServices(),
                    ));
              },
              child: Text("Additional Services")),
        ],
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Row(
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Bookings(),
                      ));
                },
                child: Text(
                  "Booking Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(width: 20),
              Spacer(),
            ],
          );
        },
      ),
    );
  }
}
