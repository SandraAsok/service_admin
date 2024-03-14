import 'package:flutter/material.dart';
import 'package:service_admin/lists.dart';

class AddLaboursForm extends StatefulWidget {
  const AddLaboursForm({super.key});

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
  @override
  Widget build(BuildContext context) {
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
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: name,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person), labelText: 'Labour name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: age,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person), labelText: 'Labour age'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: phone,
                decoration: const InputDecoration(
                    icon: Icon(Icons.phone), labelText: 'Phone number'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: address,
                maxLines: 5,
                decoration: const InputDecoration(
                    icon: Icon(Icons.home), labelText: 'Address With Pincode'),
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
                  child: Text(
                    value,
                  ),
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
                    icon: Icon(Icons.details), labelText: 'Details'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(color: Colors.white, fontSize: 25)),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 25)),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
