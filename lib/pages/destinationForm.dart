import 'dart:html';

import 'package:chippin_in/pages/tripDetailForm.dart';
import 'package:chippin_in/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chippin_in/shared/constants.dart' as Consts;
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';

class DestinationForm extends StatefulWidget {
  const DestinationForm({super.key});

  @override
  State<DestinationForm> createState() => _DestinationFormState();
}

class _DestinationFormState extends State<DestinationForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController startController = TextEditingController();
  TextEditingController finishController = TextEditingController();
  bool isLoading = false;
  LatLng? startLoc;
  LatLng? finishLoc;

  @override
  void initState() {
    super.initState();
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
                        placesStartAutoCompleteTextField(),
                        const SizedBox(height: 15),
                        placesFinishAutoCompleteTextField(),
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
                              startLoc = getCoordinatesFromAddress(
                                  startController.text) as LatLng;
                              finishLoc = getCoordinatesFromAddress(
                                  finishController.text) as LatLng;

                              sendDataToSecondScreen(context);

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

  placesStartAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: startController,
          googleAPIKey: Consts.Constants.googleApiKey,
          inputDecoration: textInputDecoration.copyWith(
              labelText: "Start",
              prefixIcon: Icon(Icons.outlined_flag,
                  color: Consts.Constants.primaryColor)),
          debounceTime: 800,
          itmClick: (Prediction prediction) {
            startController.text = prediction.description;
            print(prediction);
            startController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description.length));
          }
          // default 600 ms ,
          ),
    );
  }

  placesFinishAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: finishController,
          googleAPIKey: Consts.Constants.googleApiKey,
          inputDecoration: textInputDecoration.copyWith(
              labelText: "Finish",
              prefixIcon:
                  Icon(Icons.flag, color: Consts.Constants.primaryColor)),
          debounceTime: 800,
          itmClick: (Prediction prediction) {
            finishController.text = prediction.description;
            finishController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description.length));
          }
          // default 600 ms ,
          ),
    );
  }

  void sendDataToSecondScreen(BuildContext context) {
    String startText = startController.text;
    String finishText = finishController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TripDetailForm(startLoc: startLoc, finishLoc: finishLoc),
        ));
  }

  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    List<Location> locations =
        await GeocodingPlatform.instance.locationFromAddress(address);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } else {
      return null;
    }
  }
}
