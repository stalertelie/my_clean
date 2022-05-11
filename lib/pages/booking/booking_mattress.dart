// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:my_clean/models/price.dart';
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

class BookingMattressScreen extends StatefulWidget {
  final Services service;

  const BookingMattressScreen({Key? key, required this.service})
      : super(key: key);

  @override
  BookingMattressScreenState createState() => BookingMattressScreenState();
}

class BookingMattressScreenState extends State<BookingMattressScreen>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();

  late final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapcontroller;
  LatLng _markerPosition = LatLng(51.5, -0.09);

  final BookingBloc _bloc = BookingBloc();

  late ListProvider _listProvider;
  late AppProvider _appProvider;

  bool showMap = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? frequenceValue;

  String frequenceType = "SERVICE PONCTUEL";

  GoogleResult? _currentFeature;
  final ImagePicker _imagePicker = ImagePicker();
  dynamic _pickedImage;

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
          backgroundColor: Color(colorDefaultService),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              )),
          title: Text(
            widget.service.title!.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          bottom: PreferredSize(
              child: Text('Votre commande'), preferredSize: Size.fromHeight(1)),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                margin: EdgeInsets.only(top: showMap ? 480 : 0),
                width: double.maxFinite,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        onTap: () => showSearhPage(context))),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                                  _markerPosition = value;
                                                  setState(() {
                                                    searchCtrl.text =
                                                        "${_markerPosition.latitude} / ${_markerPosition.longitude}";
                                                  });
                                                }
                                              });
                                            });
                                          },
                                          child: Text('Carte'))
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
                            /*SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Réservez le service de nettoyage de matelas",
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 30,
                            )
                            Text(
                              "Sélectionnez votre type de matelas",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),,*/
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nombre de places",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    "Nettoyage vapeur",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
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
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        20),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                idx <= 2
                                                                    ? Text(
                                                                        e.initialNumber.toString() +
                                                                            " " +
                                                                            e.label!
                                                                                .toCapitalized()
                                                                                .toString() +
                                                                            (e.initialNumber != 1
                                                                                ? "(s)"
                                                                                : ''),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                                "SFPro",
                                                                            color:
                                                                                Color(0XFF01A6DC)),
                                                                      )
                                                                    : Text(
                                                                        e.label!
                                                                            .toCapitalized()
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontFamily:
                                                                                "SFPro",
                                                                            color:
                                                                                Color(0XFF01A6DC)),
                                                                      ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    e.quantity!
                                                                        .text
                                                                        .size(
                                                                            18)
                                                                        .bold
                                                                        .fontFamily(
                                                                            "SFPro")
                                                                        .color(const Color(
                                                                            0XFF01A6DC))
                                                                        .make(),
                                                                    const SizedBox(
                                                                      width: 50,
                                                                    ),
                                                                    InkWell(
                                                                        onTap: () => _bloc.addSofaTarification(
                                                                            e,
                                                                            -1,
                                                                            idx),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          child:
                                                                              Center(child: Icon(Icons.remove)),
                                                                          decoration:
                                                                              BoxDecoration(border: Border.all(color: e.quantity! > 0 ? Colors.grey : Colors.grey.shade300)),
                                                                        )),
                                                                    InkWell(
                                                                      onTap: () =>
                                                                          _bloc.addSofaTarification(
                                                                              e,
                                                                              1,
                                                                              idx),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        child: Center(
                                                                            child: Icon(
                                                                          Icons
                                                                              .add,
                                                                          size:
                                                                              27,
                                                                        )),
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: Colors.grey)),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ))
                                                  .toList(),
                                            )
                                          : Container());
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
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
                            AppLocalizations
                                .current.whenDoYouWantTheExecution.text
                                .size(10)
                                .fontFamily("SFPro")
                                .bold
                                .gray500
                                .make(),
                            const SizedBox(
                              height: 10,
                            ),
                            /*Container(
                              padding: EdgeInsets.all(10),
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Color(colorBlueGray)),
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
                                              color:
                                                  const Color(colorPrimary))),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    if (date.hour > 17 || date.hour < 8) {
                                      UtilsFonction.showErrorDialog(context,
                                          "Nous ne prestons pas dans cet intervalle de temps.Désolé!");
                                    } else {
                                      _bloc.setDateBooking(date);
                                    }
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.fr);
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
                                        "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE dd MMM hh:mm")}"
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
                              if (!_bloc.totalSubject.hasValue) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message:
                                            "Veuillez sélectionner au moins un type de matelas"));
                                return;
                              }
                              if (!_bloc.bookingDateSubject.hasValue) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message: "Veuillez choisir une date"));
                                return;
                              }
                              if (searchCtrl.text.isEmpty) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message:
                                            "Veuillez entrer votre adresse"));
                                return;
                              }
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
                bookingDate: _bloc.bookingDateSubject.value,
                frequence: frequence,
                services: widget.service,
                lieu: searchCtrl.text,
                amount: _bloc.totalSubject.value,
                onValidate: ({String note = ''}) {
                  noteCtrl.text = note;
                  bookNow();
                },
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
}
