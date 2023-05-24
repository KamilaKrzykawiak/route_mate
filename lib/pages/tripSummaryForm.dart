import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chippin_in/shared/constants.dart' as Consts;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../services/api.dart';
import '../widgets/type_of_fuel.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  LatLng startLocation = LatLng(0, 0);
  LatLng finishLocation = LatLng(0, 0);

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  String _mapStyle = "";
  Set<Polyline> _polylines = {};
  String distanceVal = "";
  String tripTimeVal = "";
  int doubleDistanceVal = 0;
  double tripCosts = 0;
  double tripCosts4Person = 0;

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();

    //drawRouteBetweenAddresses(startLocAddress, finishLocAddress);

    markers.add(
      Marker(
        markerId: MarkerId('startLocation'),
        position: startLocation,
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId('finishLocation'),
        position: finishLocation,
      ),
    );

    rootBundle.loadString('assets/logo/map_style.txt').then((string) {
      _mapStyle = string;
    });

    getDirections();
    calculateCosts(averFuelConsuption, numOfPeople, price, doubleDistanceVal);
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
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Trip map",
                            style: TextStyle(
                                color: Consts.Constants.primaryColor,
                                fontSize: 20)),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                                controller.setMapStyle(_mapStyle);
                                // Map controller is ready
                                // You can use it to customize the map or add markers/polylines
                              },
                              initialCameraPosition: CameraPosition(
                                target: polylineCoordinates
                                    .first, // Set initial map center
                                zoom: 5.0, // Set initial zoom level
                              ),
                              polylines: {
                                Polyline(
                                  polylineId: PolylineId('route'),
                                  color: Consts.Constants.primaryColor,
                                  width: 3,
                                  points: polylineCoordinates,
                                ),
                              }),
                        ),
                        const SizedBox(height: 15),
                        Text("Trip details",
                            style: TextStyle(
                                color: Consts.Constants.primaryColor,
                                fontSize: 20)),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Trip distance",
                                style: TextStyle(
                                    color: Consts.Constants.primaryColor,
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              distanceVal,
                              style: TextStyle(
                                  color: Consts.Constants.primaryColor,
                                  fontSize: 17),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Trip duration",
                                style: TextStyle(
                                    color: Consts.Constants.primaryColor,
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              tripTimeVal,
                              style: TextStyle(
                                  color: Consts.Constants.primaryColor,
                                  fontSize: 17),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Trip total cost",
                                style: TextStyle(
                                    color: Consts.Constants.primaryColor,
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              tripCosts.toStringAsFixed(2) + " zł",
                              style: TextStyle(
                                  color: Consts.Constants.primaryColor,
                                  fontSize: 17),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Trip cost per person",
                                style: TextStyle(
                                    color: Consts.Constants.primaryColor,
                                    fontSize: 17),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              tripCosts4Person.toStringAsFixed(2) + " zł",
                              style: TextStyle(
                                  color: Consts.Constants.primaryColor,
                                  fontSize: 17),
                              textAlign: TextAlign.left,
                            ),
                          ],
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

  /*void drawRouteBetweenAddresses(String startAddress, String endAddress) async {
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
  }*/

  Future<void> getDirections() async {
    String apiKey = Consts.Constants.googleApiKey;
    String distance = "";
    int doubleDistance = 0;
    String tripTime = "";

    startLocation = await getCoordinatesFromAddress(startLocAddress);
    finishLocation = await getCoordinatesFromAddress(finishLocAddress);

    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}&destination=${finishLocation.latitude},${finishLocation.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      List<LatLng> points = [];
      if (decodedResponse['status'] == 'OK') {
        var routes = decodedResponse['routes'][0]['legs'][0]['steps'];
        distance = decodedResponse['routes'][0]['legs'][0]['distance']['text'];
        tripTime = decodedResponse['routes'][0]['legs'][0]['duration']['text'];
        doubleDistance =
            decodedResponse['routes'][0]['legs'][0]['distance']['value'];
        for (var route in routes) {
          String pointsEncoded = route['polyline']['points'];
          List<LatLng> decodedPoints = _decodePoly(pointsEncoded);
          points.addAll(decodedPoints);
        }
      }
      setState(() {
        polylineCoordinates = points;
        distanceVal = distance;
        tripTimeVal = tripTime;
        doubleDistanceVal = doubleDistance;
      });

      calculateCosts(averFuelConsuption, numOfPeople, price, doubleDistance);
    }
  }

  List<LatLng> _decodePoly(String points) {
    List<LatLng> poly = [];
    int index = 0, len = points.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = points.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = points.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }

    return poly;
  }

  void calculateCosts(double averFuelConsuption, double numOfPeople, price,
      int doubleDistance) {
    double costs = 0;
    double costs4person = 0;

    costs = price * doubleDistance * 0.0001 * averFuelConsuption;
    costs4person = costs / numOfPeople;

    setState(() {
      tripCosts = costs;
      tripCosts4Person = costs4person;
    });
  }
}
