import 'dart:convert';

import 'package:chippin_in/type_of_fuel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

final api_key = "2GRQsj2ajyyzB9nfTSAsVY:1W0Qk11NC2CsrPmiYGdvSD";
Future<List<TypeOfFuel>> getPrices() async {
  try {
    final position = await _determinePosition();
    var poiUrl = Uri.parse(
        'https://api.collectapi.com/gasPrice/fromCoordinates?lat=${position.latitude}&lng=${position.longitude}');
    var response = await http.get(poiUrl, headers: {
      'authorization': 'apikey $api_key',
      'content-type': 'application/json'
    });
    final body = json.decode(response.body);
    return [
      TypeOfFuel("PB 95", double.parse(body['result']['gasoline']) * 4.14),
      TypeOfFuel("lpg", double.parse(body['result']['lpg']) * 4.14),
      TypeOfFuel("Diesel", double.parse(body['result']['diesel']) * 4.14)
    ];
  } catch (e) {
    print(e);
    return [];
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
