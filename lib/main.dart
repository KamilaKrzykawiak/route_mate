import 'dart:ffi';

import 'package:chippin_in/TypeOfFuel.dart';
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

class TypeOfFuel{
  late String id;
  late String name;
  late int value;

  TypeOfFuel(String id, String name, int value){
    this.id = id;
    this.name = name;
    this.value = value;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<TypeOfFuel> typeOfFuel = [new TypeOfFuel("1","PB 95", 3), new TypeOfFuel("2","PB 98", 4), new TypeOfFuel("3","Diesel", 6)];
  TypeOfFuel? selectedType;

  final TextEditingController fuelController = TextEditingController();
  final TextEditingController nokController = TextEditingController();
  final TextEditingController afkController = TextEditingController();
  final TextEditingController nopController = TextEditingController();
  String holder = '';

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // void getDropDownItem() {
  //   setState(() {
  //     holder = typeOfFuel as String;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Select fuel: '),
                    DropdownButton<TypeOfFuel>(
                      value: selectedType,
                      items: typeOfFuel
                          .map((item) => DropdownMenuItem<TypeOfFuel>(
                                value: item,
                                child:
                                    Text(item.name, style: TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (item) => setState(() => selectedType = item),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child:
                            //Printing Item on Text Widget
                            Text('${selectedType?.value.toString()} zł',
                                //tu powinny wyświetlać się wartości
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black))),

                    const SizedBox(
                      height: 5,
                    ),
                    // Text(typeOfFuels.toString()),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                const Text('number of kilometers'),
                const SizedBox(
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
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Average fuel consumption'),
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
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text('Number of people to chip in'),
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
                ),
                const SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {},
                  child: Container(
                    color: Colors.deepPurple,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(
                      'Count',
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text('result',
                          style:
                              TextStyle(color: Colors.white, fontSize: 13.0)),
                    ),
                  ],
                ),
              ]))),
    );
  }
}
