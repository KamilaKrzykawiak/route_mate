import 'package:flutter/material.dart';

import 'number_field.dart';

class DestinationForm extends StatefulWidget {
  const DestinationForm({super.key, required this.title});

  final String title;

  @override
  State<DestinationForm> createState() => _DestinationFormState();
}

class _DestinationFormState extends State<DestinationForm> {
  bool isLoading = false;
  String start = "";
  String end = ""; 

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellowAccent, Colors.orangeAccent, Colors.purple],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [                    
                    const Text(
                      'Start:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 20.0,
                      height: 5,
                    ),
                  TextFormField(
                    te
                  onChanged: (val) {
                    email = val;
                  },
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Finish:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    NumberField(
                      hint: "city",
                      onChanged: (value) => setState(() => afc = value),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
