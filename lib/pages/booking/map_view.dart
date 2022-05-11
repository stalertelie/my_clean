import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/constants/colors_constant.dart';

class MapViewScreen extends StatefulWidget {
  final LatLng initialPosition;
  const MapViewScreen(
      {Key? key, this.initialPosition = const LatLng(51.5, -0.09)})
      : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = const LatLng(51.5, -0.09);
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(colorPrimary),
        title: const Text("Cliquer pour sélectionner"),
        centerTitle: true,
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onTap: (LatLng position) {
              setState(() {
                _markerPosition = position;
              });
            },
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapcontroller = controller;
                getCurrentLocation();
              });
            },
            markers: <Marker>{
              Marker(
                markerId: const MarkerId("UserMarker"),
                position: _markerPosition,
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude ?? 0, longitude ?? 0),
              zoom: 14.4746,
            ),
          ),
        ),
        Positioned(
          child: CustomButton(
              contextProp: context,
              textProp: 'Sélectionner ce point',
              onPressedProp: () => Navigator.of(context).pop(_markerPosition)),
          left: 50,
          right: 50,
          bottom: 20,
        )
      ]),
    );
  }

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    _markerPosition = LatLng(position.latitude, position.longitude);
    Future.delayed(const Duration(milliseconds: 500),
        () => _animatedMapMove(_markerPosition, 14));
    setState(() {});
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    mapcontroller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: destLocation,
          tilt: 30.0,
          zoom: 15.0,
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
