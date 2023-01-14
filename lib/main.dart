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
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController nokController = TextEditingController();
  final TextEditingController afkController = TextEditingController();
  final TextEditingController nopController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Text('fuel type'),
                  const SizedBox(
                    height: 5,
                  ),

                  TextField(
                    controller: fuelController,

                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.deepPurple),
                      ),
                      hintText: "fuel",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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

                  ]
              ))),
    );
  }
}
