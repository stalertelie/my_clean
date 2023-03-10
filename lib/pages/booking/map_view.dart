import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/GoogleSearch/google_result.dart';
import 'package:my_clean/models/GoogleSearch/google_search_result.dart';
import 'package:my_clean/pages/booking/search_bloc.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';

class MapViewScreen extends StatefulWidget {
  final LatLng initialPosition;
  const MapViewScreen({
    Key? key,
    this.initialPosition = const LatLng(5.37, -3.99),
  }) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = const LatLng(5.37, -3.99);

  double? latitude;
  double? longitude;
  GoogleResult? googleResult;

  String? fullAddress;

  late SearchBloc _bloc;

  double listHeight = 0;

  @override
  void initState() {
    super.initState();
    _markerPosition = widget.initialPosition;
    _bloc = SearchBloc();

    _bloc.featuresStream.listen((event) {
      if (event.results != null) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            listHeight = event.results!.length * 10 + 30;
            print("====lengt");
            print(listHeight);
            print("====item");
            print(event.results!.length);
          });
        });
      }
    });
  }

  // String locaValue = "";
  TextEditingController locaValue = TextEditingController();

  onChangedLocaValue(value) {
    // locaValue.text = value;
    print(locaValue.text);
    if (value.length >= 2) {
      _bloc.getProposition(value);
    }
    // locaValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.current.location,
          style: const TextStyle(color: Colors.black),
        ),
        leading: InkWell(
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onTap: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        SizedBox(
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
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(latitude ?? 0, longitude ?? 0),
              zoom: 16,
            ),
            minMaxZoomPreference: const MinMaxZoomPreference(10, 16),
          ),
        ),
        Positioned(
          child: CustomButton(
              contextProp: context,
              fontSize: 15,
              textProp: AppLocalizations.current.useLocation.toUpperCase(),
              onPressedProp: () => Navigator.of(context)
                  .pop([_markerPosition, googleResult?.name, fullAddress])),
          left: 50,
          right: 50,
          bottom: 20,
        ),
        Positioned(
            left: 10,
            right: 10,
            top: 70,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.map_rounded,
                          color: Color(colorPrimary),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: TextField(
                          controller: locaValue,
                          onChanged: onChangedLocaValue,
                          decoration: InputDecoration(
                              hintText: "Tapez votre recherche ici",
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade300)),
                        ))
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: listHeight,
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: StreamBuilder<GoogleSearchResult>(
                          stream: _bloc.featuresStream,
                          builder: (context, snapshot2) {
                            return snapshot2.hasData
                                ? ListView.separated(
                                    itemBuilder: (context, index) => ListTile(
                                          title: Text(snapshot2
                                                  .data!.results![index].name ??
                                              ""),
                                          onTap: () {
                                            if (snapshot2.data!.results![index]
                                                        .geometry !=
                                                    null &&
                                                snapshot2.data!.results![index]
                                                        .geometry!.location !=
                                                    null) {
                                              setState(() {
                                                locaValue.text = snapshot2.data!
                                                        .results![index].name ??
                                                    '';
                                                googleResult = snapshot2
                                                    .data!.results![index];
                                                listHeight = 0;
                                                _markerPosition = LatLng(
                                                    snapshot2
                                                        .data!
                                                        .results![index]
                                                        .geometry!
                                                        .location!
                                                        .lat!,
                                                    snapshot2
                                                        .data!
                                                        .results![index]
                                                        .geometry!
                                                        .location!
                                                        .lng!);
                                                _animatedMapMove(
                                                    _markerPosition, 14);
                                              });
                                            }
                                          },
                                        ),
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: snapshot2.data!.results!.length)
                                : Container();
                          }),
                    )
                  ],
                ),
              ),
            ))
      ]),
    );
  }

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    _markerPosition = LatLng(position.latitude, position.longitude);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'fr');
      print("placemarks $placemarks");
      final getPlaceMark =
          placemarks.firstWhere((element) => element.thoroughfare != null);

      setState(() {
        fullAddress = getPlaceMark.thoroughfare;
      });

      print("fullAddress $fullAddress");
    } catch (e) {
      _showDialog(e.toString());
    }

    print("POSITION ${position.latitude} ${position.longitude}");
    Future.delayed(const Duration(milliseconds: 500),
        () => _animatedMapMove(_markerPosition, 14));
    setState(() {});
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: message);
      },
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    mapcontroller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: destLocation,
          tilt: 30.0,
          zoom: 16.0,
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

    print("HERE");

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
