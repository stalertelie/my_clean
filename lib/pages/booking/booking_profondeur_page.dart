// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

//import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_clean/constants/app_constant.dart';

//import 'package:latlong2/latlong.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/GoogleSearch/google_result.dart';
import 'package:my_clean/models/booking_tarification.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/models/tarification_object_root.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/booking/booking_bloc.dart';
import 'package:my_clean/pages/booking/booking_sucess_page.dart';
import 'package:my_clean/pages/booking/day_time_picker.dart';
import 'package:my_clean/pages/booking/search_bloc.dart';
import 'package:my_clean/pages/booking/search_page.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingProfondeurScreen extends StatefulWidget {
  final Services service;

  BookingProfondeurScreen({Key? key, required this.service}) : super(key: key);

  @override
  _BookingProfondeurScreenState createState() =>
      _BookingProfondeurScreenState();
}

class _BookingProfondeurScreenState extends State<BookingProfondeurScreen>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController noteCtrl = new TextEditingController();

  late final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = LatLng(51.5, -0.09);

  final BookingBloc _bloc = BookingBloc();

  late ListProvider _listProvider;
  late AppProvider _appProvider;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? frequenceValue;

  String frequenceType = "SERVICE PONCTUEL";

  bool isFurnish = false;

  GoogleResult? _currentFeature;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.service.services != null) {
      print('=====DLDLDLDLDLDLDLDLD=====');
      _bloc.setTarificationRoot(widget.service.services!
          .map((e) => TarificationObjectRoot(
              id: e.id!.toString(),
              libelle: e.title!,
              list: e.tarifications
                  ?.map(
                      (e) => TarificationObject(quantity: 0, tarifications: e))
                  .toList()))
          .toList());
    }

    _bloc.loadingSubject.listen((value) {
      if (value != null && value.message == MessageConstant.booking_ok) {
        GetIt.I<AppServices>()
            .messengerGlobalKey!
            .currentState!
            .clearSnackBars();
        Future.delayed(const Duration(seconds: 1), () {
          UtilsFonction.NavigateAndRemoveRight(context, BookingResultScreen());
        });
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    _appProvider = Provider.of<AppProvider>(context);
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          /*appBar: AppBar(
              backgroundColor: Color(0XFF02ABDE).withOpacity(0.5),
              toolbarHeight: 100,
              leading: Container(),
              title: Hero(
                  tag: widget.service.id.toString(),
                  child: Text(widget.service.title ?? "Service")),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ))
              ],
            ),*/
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 270,
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          //_controller.complete(controller);
                          setState(() {
                            mapcontroller = controller;
                            print(controller);
                            print("====camera set ===");
                            getCurrentLocation();
                          });
                        },
                        markers: <Marker>{
                          Marker(
                            markerId: MarkerId("UserMarker"),
                            position: _markerPosition,
                          ),
                        },
                        initialCameraPosition: _kGooglePlex,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 480),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 1),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30)),
                          color: Colors.white),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () => showSearhPage(context),
                                child: TextField(
                                  controller: searchCtrl,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      prefixIcon:
                                          Icon(FontAwesomeIcons.mapMarkerAlt)),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "APPARTEMENT MEUBLE"
                                      .text
                                      .black
                                      .bold
                                      .size(18)
                                      .make(),
                                  "Votre appartement est-il meublé ?"
                                      .text
                                      .gray500
                                      .make(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            isFurnish = true;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: isFurnish ? Color(colorBlueGray) : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Color(colorBlueGray))),
                                          child: Center(
                                            child: "Oui"
                                                .text
                                                .size(20)
                                                .bold
                                                .color(isFurnish ? Colors.white : Color(colorBlueGray))
                                                .make(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            isFurnish = false;
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: !isFurnish ? Color(colorBlueGray) : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Color(colorBlueGray))),
                                          child: Center(
                                            child: "Non"
                                                .text
                                                .size(20)
                                                .bold
                                                .color(!isFurnish ? Colors.white : Color(colorBlueGray))
                                                .make(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<List<TarificationObjectRoot>>(
                                      stream: _bloc.tarificationRootStream,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data != null
                                            ? Column(
                                                children: snapshot.data!
                                                    .mapIndexed(
                                                        (e, index) => Container(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  e.libelle
                                                                      .toUpperCase()
                                                                      .text
                                                                      .black
                                                                      .bold
                                                                      .size(20)
                                                                      .make(),
                                                                  Column(
                                                                    children: e.list !=
                                                                            null
                                                                        ? e.list!
                                                                            .map((e) =>
                                                                                tarificationITem(e, index))
                                                                            .toList()
                                                                        : [],
                                                                  )
                                                                ],
                                                              ),
                                                            ))
                                                    .toList(),
                                              )
                                            : Container();
                                      }),
                                  const SizedBox(height: 10,),
                                  "Y a-t-il autre chose que vous voudriez que nous sachions ?".text.gray500.make(),
                                  const SizedBox(height: 5,),
                                  TextField(
                                    maxLines: 10,
                                    minLines: 5,
                                    maxLength: 200,
                                    controller: noteCtrl,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                      hintText: "Saisir votre note ici",
                                      hintStyle: TextStyle(fontStyle: FontStyle.italic,fontSize: 10),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "DATE ET HEURE"
                                      .text
                                      .size(18)
                                      .fontFamily("SFPro")
                                      .bold
                                      .make(),
                                  "Quand voulez vous l'exécution du service"
                                      .text
                                      .size(10)
                                      .fontFamily("SFPro")
                                      .bold
                                      .gray500
                                      .make(),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              frequenceType =
                                                  "SERVICE PONCTUEL";
                                            });
                                          },
                                          child: timeType("SERVICE PONCTUEL")),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              frequenceType =
                                                  "SERVICE RECURRENT";
                                            });
                                          },
                                          child: timeType("SERVICE RECURRENT")),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: frequenceType ==
                                        AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                                    child: TextButton(
                                        onPressed: () {
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime.now(),
                                              onChanged: (date) {
                                            print('change $date');
                                          }, onConfirm: (date) {
                                            _bloc.setDateBooking(date);
                                          },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.fr);
                                        },
                                        child: const Text(
                                          'Choisir une date',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 15),
                                        )),
                                  ),
                                  Visibility(
                                    visible: frequenceType !=
                                        AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                                    child: MaterialButton(
                                      onPressed: () =>
                                          showBottomSheetForDayPick(),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4),
                                          "Ajouter une date".text.white.make()
                                        ],
                                      ),
                                      color: const Color(colorBlueGray),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.black,
                            ),
                            Visibility(
                              visible: frequenceType == AppConstant.FREQUENCE_BOOKING_RECURENT,
                              child: StreamBuilder<List<DayObject>>(
                                stream: _bloc.daysStream,
                                builder: (context, snapshot) {
                                  return snapshot.hasData && snapshot.data != null ? Container(
                                    height: 40*snapshot.data!.length.toDouble(),
                                    width: double.maxFinite,
                                    child: ListView.builder(itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          "Chaque ${snapshot.data![index].day}".text.make(),
                                          "à ${snapshot.data![index].time}".text.make()
                                        ],
                                      ),
                                    ),itemCount: snapshot.data!.length,),
                                  ): Container();
                                }
                              ),
                            ),
                            Visibility(
                              visible: frequenceType ==
                                  AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                              child: StreamBuilder<DateTime>(
                                  stream: _bloc.bookingDateStream,
                                  builder: (context, snapshot) {
                                    return snapshot.hasData &&
                                            snapshot.data != null
                                        ? Container(
                                            child: Center(
                                                child:
                                                    "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE, dd MMM hh:mm")}"
                                                        .text
                                                        .bold
                                                        .size(18)
                                                        .color(
                                                            Color(0XFF01A6DC))
                                                        .make()),
                                          )
                                        : Container();
                                  }),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            MaterialButton(
                              color: const Color(0XFF02ABDE),
                              onPressed: () {
                                if (_appProvider.login == null) {
                                  UtilsFonction.NavigateToRoute(
                                      context, LoginScreen());
                                } else {
                                  if (_bloc.tarificationRootSubject.value
                                          .where((element) =>
                                             element.list!.indexWhere((item) => item.quantity! > 0) ==
                                                 -1).isEmpty) {
                                    GetIt.I<AppServices>()
                                        .showSnackbarWithState(Loading(
                                            hasError: true,
                                            message:
                                                "Veuillez choisir au moins une option avant de passer votre commande"));
                                    return;
                                  }
                                  showRecapSheet();
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    "RESERVER"
                                        .text
                                        .fontFamily("SFPro")
                                        .size(18)
                                        .bold
                                        .white
                                        .make(),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  height: 120,
                  color: const Color(0XFF02ABDE).withOpacity(0.85),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Hero(
                          tag: widget.service.id.toString(),
                          child: Text(
                            widget.service.title!.toUpperCase(),
                            style: GoogleFonts.bebasNeue(
                                color: Colors.white, fontSize: 25),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget frequenceItem(Frequence frequence) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            frequence.label!.text.fontFamily("SFPro").size(15).bold.make(),
            Radio<String>(
              value: frequence.id!,
              groupValue: frequenceValue,
              onChanged: (String? value) {
                setState(() {
                  frequenceValue = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget tarificationITem(TarificationObject tarificationObject, int rootId) {
    print('rootId');
    print(rootId);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tarificationObject.tarifications!.label!
              .toUpperCase()
              .text
              .size(18)
              .bold
              .fontFamily("SFPro")
              .color(const Color(0XFF01A6DC))
              .make(),
          const SizedBox(
            width: 20,
          ),
          Row(
            children: [
              tarificationObject.quantity!.text
                  .size(18)
                  .bold
                  .fontFamily("SFPro")
                  .color(const Color(0XFF01A6DC))
                  .make(),
              const SizedBox(
                width: 50,
              ),
              InkWell(
                  onTap: () => _bloc.addTarification(
                      tarificationObject.tarifications!, -1,
                      rootId: rootId),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Center(child: Icon(Icons.remove)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: tarificationObject.quantity! > 0
                                ? Colors.grey
                                : Colors.grey.shade300)),
                  )),
              InkWell(
                onTap: () => _bloc.addTarification(
                    tarificationObject.tarifications!, 1,
                    rootId: rootId),
                child: Container(
                  height: 40,
                  width: 40,
                  child: Center(child: Icon(Icons.add)),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  showBottomSheetForDayPick() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),
        context: context,
        builder: (context) => DayTimePicker(
              callback: (day, time) {
                _bloc.addDay(day, time);
                Navigator.of(context).pop();
              },
            ));
  }

  Widget timeType(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      width: 150,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Color(colorBlueGray)),
          color: frequenceType == title ? Colors.grey.shade500 : Colors.white),
      child: Center(
        child: title.text
            .color(frequenceType == title ? Colors.white : Colors.black)
            .make(),
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    print("===animating");
    print(mapcontroller);
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

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    print(position);
    print("xxxxxx");
    if (position != null) {
      _markerPosition = LatLng(position.latitude, position.longitude);
      Future.delayed(const Duration(milliseconds: 500),
          () => _animatedMapMove(_markerPosition, 14));
      setState(() {});
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

  void showSearhPage(BuildContext ctx) {
    _scaffoldKey.currentState!.showBottomSheet((context) => SearchPage(
          callBack: (GoogleResult feature) {
            print("yyyy");
            Navigator.of(context).pop();
            _currentFeature = feature;
            searchCtrl.text = feature.name!;
            _markerPosition = LatLng(feature.geometry!.location!.lat!,
                feature.geometry!.location!.lng!);
            _animatedMapMove(_markerPosition, 15);
            setState(() {});
          },
        ));
  }

  void showRecapSheet() {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext!,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        builder: (context) => Container(
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    "RESUME DE LA COMMANDE"
                        .text
                        .color(Colors.black54)
                        .bold
                        .size(20)
                        .make(),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        "Service".text.bold.make(),
                        SizedBox(
                          width: 50,
                        ),
                        widget.service.title!.text.make()
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            "Durée".text.bold.make(),
                            SizedBox(
                              width: 50,
                            ),
                            "${_listProvider.frequenceList != null && _listProvider.frequenceList.isNotEmpty && frequenceValue != null ? _listProvider.frequenceList.firstWhere((element) => element.id == frequenceValue).label : ""}, 4 hours"
                                .text
                                .make(),
                          ],
                        ),
                        IconButton(
                          onPressed: () => () => Navigator.of(context).pop(),
                          icon: Icon(Icons.edit),
                          color: Color(colorPrimary),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            "Adresse".text.bold.make(),
                            SizedBox(
                              width: 50,
                            ),
                            (searchCtrl.text).text.make(),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.edit),
                          color: Color(colorPrimary),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<int>(
                          stream: _bloc.totalStream,
                          builder: (context, snapshot) {
                            return snapshot.hasData && snapshot.data != null ? Row(
                              children: [
                                "Montant a payer".text.bold.make(),
                                SizedBox(
                                  width: 50,
                                ),
                                "FCFA ${UtilsFonction.formatMoney(snapshot.data!)}"
                                    .text
                                    .size(18)
                                    .bold
                                    .make(),
                              ],
                            ): Container();
                          }
                        ),
                        IconButton(
                          onPressed: () => () => Navigator.of(context).pop(),
                          icon: Icon(Icons.edit),
                          color: Color(colorPrimary),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    WidgetTemplate.getActionButtonWithIcon(
                        callback: () {
                          bookNow();
                        },
                        title: "VALIDER"),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ));
  }

  bookNow() {
    Navigator.of(context).pop();
    _bloc.book(_appProvider.login!.id!,searchCtrl.text,
        "${_markerPosition.latitude},${_markerPosition.longitude}", noteCtrl.text);
  }
}
