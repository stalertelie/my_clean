// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/constants/app_constant.dart';

import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/GoogleSearch/google_result.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/price.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/models/tarification_object_root.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/booking/booking_bloc.dart';
import 'package:my_clean/pages/booking/booking_sucess_page.dart';
import 'package:my_clean/pages/booking/day_time_picker.dart';
import 'package:my_clean/pages/booking/search_page.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingCarpetScreen extends StatefulWidget {
  final Services service;

  const BookingCarpetScreen({Key? key, required this.service})
      : super(key: key);

  @override
  BookingCarpetScreenState createState() => BookingCarpetScreenState();
}

class BookingCarpetScreenState extends State<BookingCarpetScreen>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  TextEditingController sizeCtrl = TextEditingController();

  late final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = LatLng(51.5, -0.09);

  final BookingBloc _bloc = BookingBloc();

  late ListProvider _listProvider;
  late AppProvider _appProvider;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? frequenceValue;

  String frequenceType = "SERVICE PONCTUEL";
  String? selectedTapis = "tapis simple";

  GoogleResult? _currentFeature;
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickedImage = null;
  Price tarification = Price(
      id: '',
      type: '',
      priceId: 0,
      label: '',
      initialNumber: 0,
      price: 0,
      priceOperator: '',
      quantity: 0);
  int tarificationId = 0;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLatLong();

    if (widget.service != null) {
      _bloc.setSimpleTarification(widget.service.tarifications!
          .map((e) => Price(
              id: e.id,
              type: e.type,
              price: e.price,
              priceId: e.priceId,
              label: e.label,
              initialNumber: e.initialNumber,
              quantity: 0))
          .toList());
      setState(() {
        tarification = widget.service.tarifications![0];
      });
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
    });
  }

  getLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    final latPref = prefs.getDouble('latitude');
    final longPref = prefs.getDouble('longitude');

    setState(() {
      latitude = latPref;
      longitude = longPref;
    });
  }

  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Sélectionnez la source de l'image"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Caméra"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galérie"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final XFile? file = await _imagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _pickedImage = File(file.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    _appProvider = Provider.of<AppProvider>(context);
    return Builder(builder: (context) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
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
                          setState(() {
                            mapcontroller = controller;
                            getCurrentLocation();
                          });
                        },
                        markers: <Marker>{
                          Marker(
                            markerId: MarkerId("UserMarker"),
                            position: latitude != null
                                ? LatLng(latitude!, longitude!)
                                : _markerPosition,
                          ),
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(latitude!, longitude!),
                          zoom: 14.4746,
                        ),
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
                                      hintText: AppLocalizations
                                          .current.enterAnAdress,
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
                                  Text(
                                    "DÉTAILS DU SERVICE",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "À propos de notre service de nettoyage de tapis",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Réservez le service de nettoyage de tapis.",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Sélectionnez votre type de tapis",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StreamBuilder<List<Price>>(
                                    stream: _bloc.simpleTarificationStream,
                                    builder: (context, snapshot) {
                                      return (snapshot.hasData &&
                                              snapshot.data != null
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: snapshot.data!
                                                  .mapIndexed<Widget>(
                                                      (e, idx) => Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 0,
                                                                  vertical: 0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Radio<String>(
                                                                    activeColor:
                                                                        Color(
                                                                            0XFF01A6DC),
                                                                    value: e
                                                                        .label!,
                                                                    groupValue:
                                                                        selectedTapis,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        selectedTapis =
                                                                            value;
                                                                        tarification =
                                                                            e;
                                                                        tarificationId =
                                                                            idx;
                                                                      });
                                                                    },
                                                                  ),
                                                                  Text(
                                                                      e.label!),
                                                                ],
                                                              )
                                                            ],
                                                          )))
                                                  .toList(),
                                            )
                                          : Container());
                                    },
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text("Quelle est la largeur du tapis ?"),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Taille",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: TextField(
                                          autofocus: false,
                                          controller: sizeCtrl,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "M²",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.teal.shade400,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    "Avez-vous des photos que vous aimeriez partager ?",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _pickedImage == null
                                      ? GestureDetector(
                                          onTap: _pickImage,
                                          child: Image.asset(cameraIcon),
                                        )
                                      : GestureDetector(
                                          onTap: _pickImage,
                                          child: Container(
                                              width: 60.0,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: FileImage(
                                                          _pickedImage)))),
                                        ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  "Y a-t-il autre chose que vous voudriez que nous sachions ?"
                                      .text
                                      .gray500
                                      .make(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    maxLines: 10,
                                    minLines: 5,
                                    maxLength: 200,
                                    controller: noteCtrl,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        hintText: "Saisir votre note ici",
                                        hintStyle: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 10),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
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
                                children: <Widget>[
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
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Color(colorBlueGray)),
                                        color: Colors.grey.shade500),
                                    child: Center(
                                      child: Text("Service ponctuel",
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
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
                            StreamBuilder<DateTime>(
                                stream: _bloc.bookingDateStream,
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data != null
                                      ? Center(
                                          child:
                                              "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE, dd MMM hh:mm")}"
                                                  .text
                                                  .bold
                                                  .size(18)
                                                  .color(Color(0XFF01A6DC))
                                                  .make())
                                      : Container();
                                }),
                            const SizedBox(
                              height: 15,
                            ),
                            CustomButton(
                                contextProp: context,
                                onPressedProp: () {
                                  if (_appProvider.login == null) {
                                    UtilsFonction.NavigateToRoute(
                                        context, LoginScreen());
                                  } else {
                                    if (!_bloc.bookingDateSubject.hasValue) {
                                      GetIt.I<AppServices>()
                                          .showSnackbarWithState(Loading(
                                              hasError: true,
                                              message:
                                                  "Veuillez choisir une date"));
                                      return;
                                    }
                                    if (searchCtrl.text.isEmpty) {
                                      GetIt.I<AppServices>()
                                          .showSnackbarWithState(Loading(
                                              hasError: true,
                                              message:
                                                  "Veuillez entrer votre adresse"));
                                      return;
                                    }
                                    if (!_bloc.bookingDateSubject.hasValue) {
                                      GetIt.I<AppServices>()
                                          .showSnackbarWithState(Loading(
                                              hasError: true,
                                              message:
                                                  "Veuillez choisir une date"));
                                      return;
                                    }
                                    if (sizeCtrl.text.isEmpty) {
                                      GetIt.I<AppServices>()
                                          .showSnackbarWithState(Loading(
                                              hasError: true,
                                              message:
                                                  "Veuillez saisir le nombre de mètres"));
                                      return;
                                    }
                                    _bloc.addCarpetTarification(
                                        tarification,
                                        int.parse(sizeCtrl.text),
                                        tarificationId);
                                    showRecapSheet();
                                  }
                                },
                                textProp: 'Réserver'.toUpperCase()),
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

  showBottomSheetForDayPick() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        context: context,
        builder: (context) => DayTimePicker(
              callback: (day, time) {
                _bloc.addDay(day, time);
                Navigator.of(context).pop();
              },
            ));
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

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    _markerPosition = LatLng(position.latitude, position.longitude);
    Future.delayed(const Duration(milliseconds: 500),
        () => _animatedMapMove(_markerPosition, 14));
    setState(() {});
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

  void showSearhPage(BuildContext ctx) {
    _scaffoldKey.currentState!.showBottomSheet((context) => SearchPage(
          callBack: (GoogleResult feature) {
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
                            "${_listProvider.frequenceList.isNotEmpty && frequenceValue != null ? _listProvider.frequenceList.firstWhere((element) => element.id == frequenceValue).label : ""}, 4 heures"
                                .text
                                .make(),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                      children: <Widget>[
                        StreamBuilder<int>(
                            stream: _bloc.totalStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Row(
                                      children: <Widget>[
                                        "Montant à payé".text.bold.make(),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        "FCFA ${UtilsFonction.formatMoney(snapshot.data!)}"
                                            .text
                                            .size(18)
                                            .bold
                                            .make(),
                                      ],
                                    )
                                  : Container();
                            }),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                        title: "Valider".toUpperCase()),
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
    _bloc.bookSofa(
        _appProvider.login!.id!,
        searchCtrl.text,
        "${_markerPosition.latitude},${_markerPosition.longitude}",
        noteCtrl.text);
  }
}
