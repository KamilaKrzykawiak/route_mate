import 'package:chippin_in/pages/tripDetailForm.dart';
import 'package:chippin_in/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chippin_in/shared/constants.dart' as Consts;
import 'package:geolocator/geolocator.dart';
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

  //Geolocator geolocator = new Geolocator();

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
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: FloatingActionButton.extended(
                            label: Text('Set current location'),
                            foregroundColor:
                                Consts.Constants.primaryColor, // <-- Text
                            backgroundColor: Colors.white,
                            icon: Icon(
                              // <-- Icon
                              Icons.location_on,
                              size: 24.0,
                            ),

                            onPressed: () async {
                              Future<String> currentLocationAddress;
                              ;
                              currentLocationAddress =
                                  getCurrentLocationAddress();
                              String tmp = await currentLocationAddress;
                              if (tmp.isNotEmpty) {
                                startController.text = tmp;
                              }
                            },
                          ),
                        ),
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
                            child: const Text("Confirm",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                            onPressed: () {
                              sendDataToSecondScreen(context);
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
            prefixIcon:
                Icon(Icons.outlined_flag, color: Consts.Constants.primaryColor),
            contentPadding: Consts.Constants.edgeInsets,
          ),
          debounceTime: 400,
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
          debounceTime: 400,
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
    String startLocAddress = startController.text;
    String finishLocAddress = finishController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDetailForm(
              startLocAddress: startLocAddress,
              finishLocAddress: finishLocAddress),
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

  Future<String> getCurrentLocationAddress() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled) {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Handle location permission denied
        throw Exception('An error occurred! Permission is denied.');
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark currentPlacemark = placemarks[0];
        String address =
            '${currentPlacemark.street}, ${currentPlacemark.subLocality}, ${currentPlacemark.locality}, ${currentPlacemark.administrativeArea}, ${currentPlacemark.country}';
        return address;
      } else {
        // Handle no placemarks found
        throw Exception('An error occurred! No placemark found.');
      }
    } else {
      // Handle location service disabled
      throw Exception('An error occurred! Location service is disabled.');
    }
  }
}
