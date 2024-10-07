import 'dart:convert';

import 'package:favouritelocation/Pages/maps.dart';
import 'package:favouritelocation/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class Locationinput extends StatefulWidget {
  const Locationinput({super.key, required this.onselectlocation});
  final void Function(Placelocation location) onselectlocation;
  @override
  State<Locationinput> createState() => _LocationinputState();
}

class _LocationinputState extends State<Locationinput> {
  Placelocation? pickedlocation;

  var isgettinglocation = false;

  String get locationimage {
    if (pickedlocation == null) {
      return '';
    }
    final lat = pickedlocation!.latitude;
    final lng = pickedlocation!.longitude;
    return 'https://maps.gomaps.pro/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:A%7C$lat,$lng&key=AlzaSy3KZeAXR97LIs7Ki2ohbX-H1E3UgAMEGFR';
  }
//maps.googleapis.com AIzaSyBiCUJJ4ggrV3yDrwcx3nqpX6jbBc8Z9js
  Future<void> saveplace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.gomaps.pro/maps/api/geocode/json?latlng=$latitude,$longitude&key=AlzaSy3KZeAXR97LIs7Ki2ohbX-H1E3UgAMEGFR');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      pickedlocation = Placelocation(
          latitude: latitude, longitude: longitude, address: address);
      isgettinglocation = false;
    });
    widget.onselectlocation(pickedlocation!);
  }

  void getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isgettinglocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    } 
    saveplace(lat, lng);
  }

  void selectonmap() async {
    final pickedlocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (ctx) => const Mapscreen(),
    ));
    if (pickedlocation == null) {
      return;
    }
    saveplace(pickedlocation.latitude, pickedlocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewcontent = Text(
      'NO location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (pickedlocation != null) {
      previewcontent = Image.network(locationimage,
          fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }
    if (isgettinglocation) {
      previewcontent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            )),
            child: previewcontent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: getcurrentlocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Get Current location')),
            TextButton.icon(
                onPressed: selectonmap,
                icon: const Icon(Icons.map),
                label: const Text('Select location')),
          ],
        )
      ],
    );
  }
}
