import 'dart:core';

import 'package:chippin_in/api.dart';
import 'package:chippin_in/number_field.dart';
import 'package:chippin_in/type_of_fuel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChippinIn());
}

class ChippinIn extends StatelessWidget {
  const ChippinIn({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chippin in',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Chippin in'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TypeOfFuel> typeOfFuel = [];
  TypeOfFuel? selectedType;

  double nok = 0;
  double afc = 0;
  double nop = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();//odkomentować do użycia
    // getPrices().then(
    //   (value) => setState(
    //     () {
    //       typeOfFuel = value;
    //       isLoading = false;
    //     },
    //   ),
    // );
  }

  @override
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<TypeOfFuel>(
                          hint: const Text(
                            'Select fuel: ',
                            style: TextStyle(fontSize: 15),
                          ),
                          value: selectedType,
                          items: typeOfFuel
                              .map(
                                (item) => DropdownMenuItem<TypeOfFuel>(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedType = item),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 30),
                          child:
                              //Printing Item on Text Widget
                              Text(
                            '${selectedType?.value.toStringAsFixed(2)} zł  per liter',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'number of kilometers:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 20.0,
                      height: 5,
                    ),
                    NumberField(
                      hint: "number of kilometers",
                      onChanged: (value) => setState(() => nok = value),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Average fuel consumption:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    NumberField(
                      hint: "Average fuel consumption",
                      onChanged: (value) => setState(() => afc = value),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                      'Number of people to chip in:',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    NumberField(
                      hint: "Number of people to chip in",
                      onChanged: (value) => setState(() => nop = value),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ElevatedButton(
                      onPressed: selectedType == null
                          ? null
                          : () {
                              //turnerry expression
                              double sum = (selectedType!.value *
                                  nok *
                                  0.01 *
                                  afc /
                                  nop);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: AlertDialog(
                                      backgroundColor: Colors.lightBlue,
                                      content: Text(
                                        'You have to chip in ${sum.toStringAsFixed(2)} zł each.',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                      child: Text(
                        'COUNT',
                        style: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(40),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
