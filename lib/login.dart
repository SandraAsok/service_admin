// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service_admin/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    signin() async {
      try {
        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.purple,
            content: const Text("Admin logged in successfully"),
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          ));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.purple,
          content: const Text("something went wrong"),
          action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
        ));
        log("ERROR: $e");
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  label: const Text('Email'),
                  hintText: 'Type Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  label: const Text('Password'),
                  hintText: 'Type Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                final SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setString('email', email.text);
                signin();
              },
              style: const ButtonStyle(
                  side: MaterialStatePropertyAll<BorderSide>(
                      BorderSide(color: Colors.purple)),
                  fixedSize:
                      MaterialStatePropertyAll<Size>(Size.fromHeight(50)),
                  textStyle: MaterialStatePropertyAll<TextStyle>(
                      TextStyle(fontSize: 18))),
              child: const Text("Admin Login")),
        ],
      ),
    );
  }
}
