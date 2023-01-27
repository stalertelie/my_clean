// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/models/GoogleSearch/google_result.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/models/tarification_object_root.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/booking/booking_bloc.dart';
import 'package:my_clean/pages/booking/booking_recap.dart';
import 'package:my_clean/pages/booking/booking_sucess_page.dart';
import 'package:my_clean/pages/booking/day_time_picker.dart';
import 'package:my_clean/pages/booking/map_view.dart';
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

class BookingVehicleScreen extends StatefulWidget {
  final Services service;

  const BookingVehicleScreen({Key? key, required this.service})
      : super(key: key);

  @override
  BookingVehicleScreenState createState() => BookingVehicleScreenState();
}

class BookingVehicleScreenState extends State<BookingVehicleScreen>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();

  late final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = LatLng(51.5, -0.09);

  final BookingBloc _bloc = BookingBloc();

  late ListProvider _listProvider;
  late AppProvider _appProvider;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? frequenceValue;

  String frequenceType = "SERVICE PONCTUEL";

  bool isSelected = true;
  int activeCarTypeIndex = 0;
  bool? isMoteurBerlineChecked = false;
  bool? isInterieurBerlineChecked = false;
  bool? isCompletBerlineChecked = false;

  bool? isMoteur4x4Checked = false;
  bool? isInterieur4x4Checked = false;
  bool? isComplet4x4Checked = false;

  bool showMap = false;

  GoogleResult? _currentFeature;
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickedImage = null;

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

    if (widget.service.services != null) {
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
      return Scaffold(
        backgroundColor: Color(colorDefaultService),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              )),
          backgroundColor: Color(colorDefaultService),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            widget.service.title!.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          bottom: PreferredSize(
              child: Text(AppLocalizations.current.yourOrder),
              preferredSize: Size.fromHeight(1)),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: showMap ? 480 : 0),
                    width: double.maxFinite,
                    color: Color(colorDefaultService),
                    /*decoration: BoxDecoration(
                        border: Border.all(color: Colors.black45, width: 1),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                        color: Colors.white),*/
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'images/icons/map-marker.svg',
                                      width: 40,
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                height: 40,
                                                child: Text(searchCtrl.text)),
                                            onTap: () =>
                                                showSearhPage(context))),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  //showMap = !showMap;
                                                  UtilsFonction
                                                      .NavigateToRouteAndWait(
                                                          context,
                                                          MapViewScreen(
                                                            initialPosition:
                                                                _markerPosition,
                                                          )).then((value) {
                                                    if (value != null) {
                                                      _markerPosition =
                                                          value[0];
                                                      setState(() {
                                                        if (value[1] == null) {
                                                          searchCtrl
                                                              .text = value[
                                                                  2] ??
                                                              "${_markerPosition.latitude} / ${_markerPosition.longitude}";
                                                        } else {
                                                          searchCtrl.text =
                                                              value[1];
                                                        }
                                                      });
                                                    }
                                                  });
                                                });
                                              },
                                              child: Text(
                                                  AppLocalizations.current.map))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*Text(
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
                                  "À propos de notre service automobile",
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Réservez le service automobile et nos professionnels vous aideront à redonner à votre véhicule son lustre d'antan.",
                                  style: TextStyle(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),*/
                                Text(
                                  AppLocalizations.current.vehiculeType,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                StreamBuilder<List<TarificationObjectRoot>>(
                                  stream: _bloc.tarificationRootStream,
                                  builder: (context, snapshot) {
                                    return (snapshot.hasData &&
                                            snapshot.data != null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: snapshot.data!
                                                    .mapIndexed<Widget>(
                                                      (carType, idx) =>
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                right: 8,
                                                              ),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isSelected =
                                                                        true;
                                                                    activeCarTypeIndex =
                                                                        idx;
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 100,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  decoration: BoxDecoration(
                                                                      color: isSelected && activeCarTypeIndex == idx
                                                                          ? Color(colorGrey).withOpacity(
                                                                              0.7)
                                                                          : Colors
                                                                              .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      carType
                                                                          .libelle
                                                                          .toCapitalized(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: isSelected && activeCarTypeIndex == idx
                                                                              ? Colors.white
                                                                              : Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                    )
                                                    .toList(),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.white),
                                                child: Column(
                                                  children: [
                                                    Visibility(
                                                        visible:
                                                            activeCarTypeIndex ==
                                                                0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: snapshot
                                                              .data![
                                                                  activeCarTypeIndex]
                                                              .list!
                                                              .mapIndexed<
                                                                  Widget>((tarif,
                                                                      idx) =>
                                                                  CheckboxListTile(
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .trailing,
                                                                    title: Text(
                                                                      tarif
                                                                          .tarifications!
                                                                          .label
                                                                          .toString()
                                                                          .toCapitalized(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    value: idx ==
                                                                            0
                                                                        ? isMoteurBerlineChecked
                                                                        : idx ==
                                                                                1
                                                                            ? isInterieurBerlineChecked
                                                                            : isCompletBerlineChecked,
                                                                    onChanged:
                                                                        (value) {
                                                                      onChangedBerlineChecked(
                                                                          idx,
                                                                          value!,
                                                                          tarif,
                                                                          activeCarTypeIndex);
                                                                    },
                                                                    activeColor:
                                                                        Color(
                                                                            colorBlueGray),
                                                                    checkColor:
                                                                        Colors
                                                                            .black,
                                                                  ))
                                                              .toList(),
                                                        )),
                                                    Visibility(
                                                        visible:
                                                            activeCarTypeIndex ==
                                                                1,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: snapshot
                                                              .data![
                                                                  activeCarTypeIndex]
                                                              .list!
                                                              .mapIndexed<
                                                                  Widget>((tarif,
                                                                      idx) =>
                                                                  CheckboxListTile(
                                                                    controlAffinity:
                                                                        ListTileControlAffinity
                                                                            .trailing,
                                                                    title: Text(
                                                                        tarif
                                                                            .tarifications!
                                                                            .label
                                                                            .toString()
                                                                            .toCapitalized(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    value: idx ==
                                                                            0
                                                                        ? isInterieur4x4Checked
                                                                        : idx ==
                                                                                1
                                                                            ? isComplet4x4Checked
                                                                            : isMoteur4x4Checked,
                                                                    onChanged:
                                                                        (value) {
                                                                      onChanged4x4Checked(
                                                                          idx,
                                                                          value!,
                                                                          tarif,
                                                                          activeCarTypeIndex);
                                                                    },
                                                                    activeColor:
                                                                        Color(
                                                                            colorBlueGray),
                                                                    checkColor:
                                                                        Colors
                                                                            .black,
                                                                  ))
                                                              .toList(),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container());
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                /*Text(
                                  "Avez-vous des photos que vous aimeriez partager ?",
                                  style: TextStyle(color: Colors.grey.shade700),
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
                                ),*/
                              ],
                            ),
                          ),
                          /*Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),*/
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AppLocalizations.current.dateAndHour.text
                                    .size(18)
                                    .fontFamily("SFPro")
                                    .bold
                                    .make(),

                                /*const SizedBox(
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
                                ),*/
                                TextButton(
                                    onPressed: () {
                                      DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime.now(),
                                          theme: DatePickerTheme(
                                              itemStyle: TextStyle(
                                                  color: const Color(colorPrimary))),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print(GetIt.I<AppServices>().lang ==
                                            "fr");
                                        if (date.hour > 16 || date.hour < 8) {
                                          UtilsFonction.showErrorDialog(
                                              context,
                                              AppLocalizations
                                                  .current.erroTimeFrame);
                                        } else {
                                          _bloc.setDateBooking(date);
                                        }
                                      },
                                          currentTime: _bloc.bookingDateSubject
                                                      .hasValue &&
                                                  _bloc.bookingDateSubject
                                                          .value !=
                                                      null
                                              ? _bloc.bookingDateSubject.value
                                              : DateTime.now(),
                                          locale:
                                              GetIt.I<AppServices>().lang == 'fr'
                                                  ? LocaleType.fr
                                                  : LocaleType.en);
                                    },
                                    child: Text(
                                      AppLocalizations.current.selectDate,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 15),
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<DateTime>(
                              stream: _bloc.bookingDateStream,
                              builder: (context, snapshot) {
                                return snapshot.hasData && snapshot.data != null
                                    ? Center(
                                        child:
                                            "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE dd MMM H:mm")}"
                                                .text
                                                .bold
                                                .size(18)
                                                .color(Color(0XFF01A6DC))
                                                .make())
                                    : Container();
                              }),
                          const SizedBox(
                            height: 35,
                          ),
                          CustomButton(
                              contextProp: context,
                              onPressedProp: () {
                                if (_appProvider.login == null) {
                                  UtilsFonction.NavigateToRoute(
                                      context,
                                      LoginScreen(
                                        toPop: true,
                                      ));
                                } else {
                                  // if (_bloc.tarificationRootSubject.value
                                  //     .where((element) =>
                                  //         element.list!
                                  //             .indexWhere((item) => item.quantity! > 0) ==
                                  //         -1)
                                  //     .isEmpty) {
                                  //   GetIt.I<AppServices>().showSnackbarWithState(Loading(
                                  //       hasError: true,
                                  //       message: AppLocalizations
                                  //           .current.pleaseChooseAtLeastOneOption));
                                  //   return;
                                  // }
                                  if (searchCtrl.text.isEmpty) {
                                    GetIt.I<AppServices>()
                                        .showSnackbarWithState(Loading(
                                            hasError: true,
                                            message: AppLocalizations
                                                .current.adressError));
                                    return;
                                  }
                                  if (!_bloc.bookingDateSubject.hasValue) {
                                    GetIt.I<AppServices>()
                                        .showSnackbarWithState(Loading(
                                            hasError: true,
                                            message: AppLocalizations
                                                .current.dateError));
                                    return;
                                  }
                                  showRecapSheet();
                                }
                              },
                              textProp:
                                  AppLocalizations.current.order.toUpperCase())
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*Positioned(
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
            )*/
          ],
        ),
        // bottomNavigationBar: ,
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
    /*_scaffoldKey.currentState!.showBottomSheet((context) => SearchPage(
          callBack: (GoogleResult feature) {
            Navigator.of(context).pop();
            _currentFeature = feature;
            searchCtrl.text = feature.name!;
            _markerPosition = LatLng(feature.geometry!.location!.lat!,
                feature.geometry!.location!.lng!);
            _animatedMapMove(_markerPosition, 15);
            setState(() {});
          },
        ));*/
    UtilsFonction.NavigateToRouteAndWait(
        context,
        MapViewScreen(
          initialPosition: _markerPosition,
        )).then((value) {
      if (value != null) {
        _markerPosition = value[0];
        setState(() {
          if (value[1] == null) {
            searchCtrl.text =
                "${_markerPosition.latitude} / ${_markerPosition.longitude}";
          } else {
            searchCtrl.text = value[1];
          }
        });
      }
    });
  }

  void showRecapSheet() {
    Frequence? frequence =
        _listProvider.frequenceList.isNotEmpty && frequenceValue != null
            ? _listProvider.frequenceList
                .firstWhere((element) => element.id == frequenceValue)
            : null;
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.only(top: 60),
              child: BookingRecapScreen(
                frequence: frequence,
                bookingDate: _bloc.bookingDateSubject.value,
                services: widget.service,
                lieu: searchCtrl.text,
                amount: _bloc.totalSubject.value,
                onValidate: ({String note = ''}) {
                  noteCtrl.text = note;
                  bookNow();
                },
              ),
            ));
    return;
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
    _bloc.book(
        _appProvider.login!.id!,
        searchCtrl.text,
        "${_markerPosition.latitude},${_markerPosition.longitude}",
        noteCtrl.text);
  }

  onChangedBerlineChecked(int cleaningTypeIndex, bool value,
      TarificationObject tarif, int activeCarTypeIndex) {
    switch (cleaningTypeIndex) {
      case 0:
        setState(() {
          isMoteurBerlineChecked = value;
        });

        break;
      case 1:
        setState(() {
          isInterieurBerlineChecked = value;
        });

        break;
      default:
        setState(() {
          isCompletBerlineChecked = value;
        });
    }
    _bloc.addTarificationSimply(
        tarif.tarifications!, value == true ? 1 : -1, activeCarTypeIndex,
        cleaningTypeIndex: cleaningTypeIndex);
  }

  onChanged4x4Checked(int cleaningTypeIndex, bool value,
      TarificationObject tarif, int activeCarTypeIndex) {
    switch (cleaningTypeIndex) {
      case 0:
        setState(() {
          isInterieur4x4Checked = value;
        });

        break;
      case 1:
        setState(() {
          isComplet4x4Checked = value;
        });

        break;
      default:
        setState(() {
          isMoteur4x4Checked = value;
        });
    }
    _bloc.addTarificationSimply(
        tarif.tarifications!, value == true ? 1 : -1, activeCarTypeIndex,
        cleaningTypeIndex: cleaningTypeIndex);
  }
}
