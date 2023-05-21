import 'package:chippin_in/pages/tripSummaryForm.dart';
import 'package:chippin_in/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chippin_in/shared/constants.dart' as Consts;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api.dart';
import '../widgets/type_of_fuel.dart';

class TripDetailForm extends StatefulWidget {
  final String startLocAddress;
  final String finishLocAddress;
  TripDetailForm(
      {Key? key, required this.startLocAddress, required this.finishLocAddress})
      : super(key: key);

  @override
  State<TripDetailForm> createState() => _TripDetailFormState(
      startLocAddress: startLocAddress, finishLocAddress: finishLocAddress);
}

class _TripDetailFormState extends State<TripDetailForm> {
  final String startLocAddress;
  final String finishLocAddress;
  _TripDetailFormState(
      {required this.startLocAddress, required this.finishLocAddress});

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<TypeOfFuel> typeOfFuel = [];
  TypeOfFuel? selectedType;

  double averFuelConsuption = 0;
  double numOfPeople = 0;
  double price = 0;

  @override
  void initState() {
    super.initState();

    getPrices().then(
      (value) => setState(
        () {
          typeOfFuel = value;
          isLoading = false;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        DropdownButtonFormField<TypeOfFuel>(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Select fuel:",
                              prefixIcon: Icon(Icons.local_gas_station,
                                  color: Consts.Constants.primaryColor)),
                          style:
                              TextStyle(color: Consts.Constants.primaryColor),
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
                            '${selectedType?.value.toStringAsFixed(2)} zł per liter',
                            style: TextStyle(
                                fontSize: 15,
                                color: Consts.Constants.primaryColor),
                          ),
                        ),
                        //placesStartAutoCompleteTextField(),
                        TextFormField(                          
                          decoration: textInputDecoration.copyWith(
                              labelText: "Average fuel consumption:",
                              prefixIcon: Icon(Icons.local_fire_department,
                                  color: Consts.Constants.primaryColor)),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Value is incorrect!";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            averFuelConsuption = val as double;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(                          
                          decoration: textInputDecoration.copyWith(
                              labelText: "Number of people to chip in:",
                              prefixIcon: Icon(Icons.hail,
                                  color: Consts.Constants.primaryColor)),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Value is incorrect!";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            numOfPeople = val as double;
                          },
                        ),
                        //placesFinishAutoCompleteTextField(),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Consts.Constants.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text("Zatwierdź",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onPressed: () {
                              price = selectedType!.value;
                              sendDataToThirdScreen(context);
                              //register();
                              //getStartCoordinates();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  void sendDataToThirdScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripSummaryForm(
              startLocAddress: startLocAddress,
              finishLocAddress: finishLocAddress,
              averFuelConsuption: averFuelConsuption,
              numOfPeople: numOfPeople,
              price: price,),
        ));
  }
}
