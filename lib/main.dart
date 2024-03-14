import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/home.dart';
import 'package:service_admin/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCKRz2BwiB_VWW68Fmtb-e3A_vZhEeXteM",
      appId: "1:632744309940:android:063901222a9068f27393e1",
      messagingSenderId: "632744309940",
      projectId: "atozservice-b6c16",
    ),
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

String? finalemail;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    getValidationData().whenComplete(() async {
      if (finalemail == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    });
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalemail = obtainedEmail!;
    });
    log(finalemail!);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
