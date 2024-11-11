import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps_Screen extends StatefulWidget {
  const Maps_Screen({super.key});

  @override
  State<Maps_Screen> createState() => _Maps_ScreenState();
}

class _Maps_ScreenState extends State<Maps_Screen> {
  final Completer<GoogleMapController> _completer = Completer();
  List<Marker> _markers = [];
  List<Marker> _markerList = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(-3.38193, 29.36142),
        infoWindow: InfoWindow(title: 'Marker 1')),
    Marker(
        markerId: MarkerId('2'),
        position: LatLng(-1.94995, 30.05885),
        infoWindow: InfoWindow(title: 'Marker 2')),
  ];

  @override
  void initState() {
    super.initState();
    _markers.addAll(_markerList);
  }

  final _cameraPosition =
      const CameraPosition(target: LatLng(-3.38193, 29.36142), zoom: 15);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps Screen'),
        ),
        body: GoogleMap(initialCameraPosition: _cameraPosition));
  }
}
