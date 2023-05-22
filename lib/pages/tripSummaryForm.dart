
import 'package:flutter/material.dart';
import 'package:chippin_in/shared/constants.dart' as Consts;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../services/api.dart';
import '../widgets/type_of_fuel.dart';

class TripSummaryForm extends StatefulWidget {
  final String startLocAddress;
  final String finishLocAddress;
  final double averFuelConsuption;
  final double numOfPeople;
  final double price;

  TripSummaryForm(
      {Key? key,
      required this.startLocAddress,
      required this.finishLocAddress,
      required this.averFuelConsuption,
      required this.numOfPeople,
      required this.price})
      : super(key: key);

  @override
  State<TripSummaryForm> createState() => _TripSummaryFormState(
      startLocAddress: startLocAddress,
      finishLocAddress: finishLocAddress,
      averFuelConsuption: averFuelConsuption,
      numOfPeople: numOfPeople,
      price: price);
}

class _TripSummaryFormState extends State<TripSummaryForm> {
  String startLocAddress;
  String finishLocAddress;
  double averFuelConsuption = 0;
  double numOfPeople = 0;
  double price = 0;

  _TripSummaryFormState(
      {required this.startLocAddress,
      required this.finishLocAddress,
      required this.averFuelConsuption,
      required this.numOfPeople,
      required this.price});

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  List<TypeOfFuel> typeOfFuel = [];
  TypeOfFuel? selectedType;

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    drawRouteBetweenAddresses(startLocAddress, finishLocAddress);

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
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(0, 0), // Set initial map center
                            zoom: 12.0, // Set initial zoom level
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            // Map controller is ready
                            // You can use it to customize the map or add markers/polylines
                          },
                          polylines: _polylines,
                        ),
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
                              print("start address:" + startLocAddress);
                              print("finish address: " + finishLocAddress);
                              print("price: " + price.toString());
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

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    List<Location> locations =
        await GeocodingPlatform.instance.locationFromAddress(address);

    Location location = locations.first;
    return LatLng(location.latitude, location.longitude);
  }

  void drawRouteBetweenAddresses(String startAddress, String endAddress) async {
    // Fetch coordinates for the start and end addresses
    LatLng startCoordinates = await getCoordinatesFromAddress(startAddress);
    LatLng endCoordinates = await getCoordinatesFromAddress(endAddress);

    // Remove existing polylines from the set
    _polylines.clear();

    // Create a polyline to represent the route
    Polyline route = Polyline(
      polylineId: PolylineId('route'),
      points: [startCoordinates, endCoordinates],
      color: Colors.blue,
      width: 3,
    );

    // Add the new polyline to the set
    _polylines.add(route);

    double minLat = _polylines.first.points.first.latitude;
    double minLong = _polylines.first.points.first.longitude;
    double maxLat = _polylines.first.points.first.latitude;
    double maxLong = _polylines.first.points.first.longitude;
    _polylines.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });

    // Update the map
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        20));
  }


}
