import 'dart:core';
import 'dart:ffi';

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

class TypeOfFuel {
  final String id;
  final String name;
  final double value;

  TypeOfFuel(this.id, this.name, this.value) {}
}

class _MyHomePageState extends State<MyHomePage> {
  List<TypeOfFuel> typeOfFuel = [
    new TypeOfFuel("1", "PB 95", 6.60),
    new TypeOfFuel("2", "PB 98", 7.04),
    new TypeOfFuel("3", "Diesel", 7.68)
  ];
  TypeOfFuel? selectedType;

  final TextEditingController fuelController = TextEditingController();
  final TextEditingController nokController = TextEditingController();
  final TextEditingController afkController = TextEditingController();
  final TextEditingController nopController = TextEditingController();
  String holder = '';

  late double fp = 0;
  late double nok = 0;
  late double afc = 0;
  late double nop = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    fuelController.dispose();
    nokController.dispose();
    afkController.dispose();
    nopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(


    decoration: const BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.yellowAccent, Colors.orangeAccent, Colors.purple])),

      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select fuel: ',
                      style: TextStyle(fontSize: 15),
                    ),
                    DropdownButton<TypeOfFuel>(
                        value: selectedType,
                        items: typeOfFuel
                            .map((item) => DropdownMenuItem<TypeOfFuel>(
                                  value: item,
                                  child: Text(item.name,
                                      style: TextStyle(fontSize: 15)),
                                ))
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedType = item;
                            fp = item?.value ?? 0;
                          });
                        }
                        ),
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child:
                            //Printing Item on Text Widget
                            Text('${selectedType?.value} zł  per liter',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black))),

                    const SizedBox(
                      width: 20.0,
                      height: 20.0,
                    ),
                    // Text(typeOfFuels.toString()),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                const Text('number of kilometers:', style: TextStyle(fontSize: 15),),

                const SizedBox(
                  width: 20.0,
                  height: 5,
                ),
                TextField(
                  controller: nokController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    hintText: "number of kilometers",

                  ),
                  onChanged: (text) {
                    nok = double.parse(text);
                  },
                ),
                const SizedBox(
                  width: 20.0,
                  height: 30.0,
                ),
                const Text('Average fuel consumption:', style: TextStyle(fontSize: 15),),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: afkController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    hintText: "Average fuel consumption",
                  ),
                  onChanged: (text) {
                    afc = double.parse(text);
                  },
                ),
                const SizedBox(
                  width: 20.0,
                  height: 30.0,
                ),
                const Text('Number of people to chip in:', style: TextStyle(fontSize: 15),),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: nopController,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Colors.deepPurple),
                    ),
                    hintText: "Number of people to chip in",
                  ),
                  onChanged: (text) {
                    nop = double.parse(text);
                  },
                ),
                const SizedBox(
                  width: 20.0,
                  height: 30.0,
                ),
                TextButton(
                  onPressed: () {
                    double sum = (fp * nok * 0.01 * afc / nop);
                    // double akfDividedBy = (afc * 0.01);
                    // double intermediateSum = (nok * akfDividedBy);
                    // double sum =
                    //     (intermediateSum / nop * fp);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return Container(

                          child: AlertDialog(
                            backgroundColor: Colors.lightBlue,
                            content: Text('You have to chip in $sum zł each.', style: TextStyle(fontSize: 15),),
                          ),
                        );
                      },
                    );
                  },
                  child: Text('COUNT',
                      style:
                          TextStyle(color: Colors.yellowAccent, fontSize: 15.0)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: CircleBorder(),
                      padding: EdgeInsets.all(40),
                  ),
                )
              ]))),
    );
  }
}
