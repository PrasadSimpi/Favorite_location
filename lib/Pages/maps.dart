import 'package:favouritelocation/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({
    super.key,
    this.location =
        const Placelocation(latitude: 19.192, longitude: 72.821, address: ''),
    this.isSelecting = true,
  });
  final Placelocation location;
  final bool isSelecting;
  @override
  State<Mapscreen> createState() {
    return _MapscreenState();
  }
}

class _MapscreenState extends State<Mapscreen> {
  LatLng? pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(pickedlocation);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
          onTap: !widget.isSelecting
              ? null
              : (position) {
                  setState(() {
                    pickedlocation = position;
                  });
                },
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.latitude, 
                  widget.location.longitude),
              zoom: 16),
          markers: (pickedlocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: const MarkerId('m1'),
                    position: pickedlocation ??
                        LatLng(widget.location.latitude,
                            widget.location.longitude),
                  ),
                }),
    );
  }
}
