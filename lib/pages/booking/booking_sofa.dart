// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';

//import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/constants/app_constant.dart';
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
import 'package:my_clean/pages/booking/booking_recap.dart';
import 'package:my_clean/pages/booking/booking_sucess_page.dart';
import 'package:my_clean/pages/booking/day_time_picker.dart';
import 'package:my_clean/pages/booking/map_view.dart';
import 'package:my_clean/pages/booking/search_bloc.dart';
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
import 'package:my_clean/extensions/extensions.dart';

class BookingSofaScreen extends StatefulWidget {
  final Services service;

  BookingSofaScreen({Key? key, required this.service}) : super(key: key);

  @override
  _BookingSofaScreenState createState() => _BookingSofaScreenState();
}

class _BookingSofaScreenState extends State<BookingSofaScreen>
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

  GoogleResult? _currentFeature;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  int activeCarTypeIndex = 0;

  bool isSelected = true;

  double? latitude;
  double? longitude;

  bool showMap = false;

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
      _bloc.tarificationRootSubject.value[0].list!.forEach((element) {
        element.quantity = element.tarifications?.min;
      });
      _bloc.calculateDetail(0);
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

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    _appProvider = Provider.of<AppProvider>(context);
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Color(colorDefaultService),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
              )),
          backgroundColor: Color(colorDefaultService),
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
        key: _scaffoldKey,
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
                                                  _markerPosition = value[0];
                                                  setState(() {
                                                    if (value[1] == null) {
                                                      searchCtrl.text =
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                              "À propos de notre service de nettoyage de canapés",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Réservez le service de nettoyage de canapés",
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 30,
                            ),*/
                            Text(
                              AppLocalizations.current.selectMatiere,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<List<TarificationObjectRoot>>(
                                stream: _bloc.tarificationRootStream,
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data != null
                                      ? Column(
                                          children: [
                                            Row(
                                              children: snapshot.data!
                                                  .mapIndexed<Widget>(
                                                    (carType, idx) => Container(
                                                        margin: EdgeInsets.only(
                                                          right: 8,
                                                        ),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isSelected = true;
                                                              activeCarTypeIndex =
                                                                  idx;
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 35,
                                                            width: 100,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    7),
                                                            decoration: BoxDecoration(
                                                                color: isSelected &&
                                                                        activeCarTypeIndex ==
                                                                            idx
                                                                    ? Color(colorGrey)
                                                                        .withOpacity(
                                                                            0.6)
                                                                    : Colors
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black)),
                                                            child: Center(
                                                              child: Text(
                                                                carType.libelle
                                                                    .toCapitalized(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: isSelected &&
                                                                            activeCarTypeIndex ==
                                                                                idx
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  )
                                                  .toList(),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppLocalizations
                                                      .current.numberPlace.text
                                                      .size(20)
                                                      .bold
                                                      .make(),
                                                  AppLocalizations.current
                                                      .steamCleaning.text
                                                      .size(20)
                                                      .make(),
                                                  Column(
                                                      children: snapshot.data!
                                                          .mapIndexed(
                                                              (e, index) =>
                                                                  Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          children: e.list != null
                                                                              ? e.list!.map((e) => index == activeCarTypeIndex ? tarificationITem(e, index) : Container()).toList()
                                                                              : [],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ))
                                                          .toList()),
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : Container();
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppLocalizations.current.dateAndHour.text
                                .size(18)
                                .fontFamily("SFPro")
                                .bold
                                .make(),
                            /*AppLocalizations
                                .current.whenDoYouWantTheExecution.text
                                .size(10)
                                .fontFamily("SFPro")
                                .bold
                                .gray500
                                .make(),*/
                            /*const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        frequenceType = "SERVICE PONCTUEL";
                                      });
                                    },
                                    child: timeType("SERVICE PONCTUEL")),
                                const SizedBox(
                                  width: 30,
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        frequenceType = "SERVICE RECURRENT";
                                      });
                                    },
                                    child: timeType("SERVICE RECURRENT")),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),*/
                            Visibility(
                              visible: frequenceType ==
                                  AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                              child: TextButton(
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
                                        UtilsFonction.showErrorDialog(
                                            context,
                                            AppLocalizations
                                                .current.erroTimeFrame);
                                      } else {
                                        _bloc.setDateBooking(date);
                                      }
                                    },
                                        currentTime: DateTime.now(),
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
                            ),
                            Visibility(
                              visible: frequenceType !=
                                  AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                              child: MaterialButton(
                                onPressed: () => showBottomSheetForDayPick(),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4),
                                    "Ajouter une date".text.white.make()
                                  ],
                                ),
                                color: const Color(colorBlueGray),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: frequenceType ==
                            AppConstant.FREQUENCE_BOOKING_RECURENT,
                        child: StreamBuilder<List<DayObject>>(
                            stream: _bloc.daysStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Container(
                                      height:
                                          40 * snapshot.data!.length.toDouble(),
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              "Chaque ${snapshot.data![index].day}"
                                                  .text
                                                  .make(),
                                              "à ${snapshot.data![index].time}"
                                                  .text
                                                  .make()
                                            ],
                                          ),
                                        ),
                                        itemCount: snapshot.data!.length,
                                      ),
                                    )
                                  : Container();
                            }),
                      ),
                      Visibility(
                        visible: frequenceType ==
                            AppConstant.FREQUENCE_BOOKING_PONCTUAL,
                        child: StreamBuilder<DateTime>(
                            stream: _bloc.bookingDateStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData && snapshot.data != null
                                  ? Container(
                                      child: Center(
                                          child:
                                              "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE dd MMM H:m")}"
                                                  .text
                                                  .bold
                                                  .size(18)
                                                  .color(Color(0XFF01A6DC))
                                                  .make()),
                                    )
                                  : Container();
                            }),
                      ),
                      const SizedBox(
                        height: 60,
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
                              if (_bloc.totalSubject.value == 0) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message: AppLocalizations.current
                                            .pleaseChooseAtLeastOneOption));
                                return;
                              }
                              if (searchCtrl.text.isEmpty) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message: AppLocalizations
                                            .current.adressError));
                                return;
                              }
                              if (!_bloc.bookingDateSubject.hasValue) {
                                GetIt.I<AppServices>().showSnackbarWithState(
                                    Loading(
                                        hasError: true,
                                        message: AppLocalizations
                                            .current.dateError));
                                return;
                              }
                              showRecapSheet();
                            }
                          },
                          textProp:
                              AppLocalizations.current.order.toUpperCase()),
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
              //.color(const Color(0XFF01A6DC))
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
                      rootId: rootId, isOperatorValueNull: true),
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
                    rootId: rootId, isOperatorValueNull: true),
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
                        Text(widget.service.title!.substring(0, 17) + '...')
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
                            "${_listProvider.frequenceList != null && _listProvider.frequenceList.isNotEmpty && frequenceValue != null ? _listProvider.frequenceList.firstWhere((element) => element.id == frequenceValue).label : ""}, 4 heures"
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
                              return snapshot.hasData && snapshot.data != null
                                  ? Row(
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
                                    )
                                  : Container();
                            }),
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
    _bloc.book(
      _appProvider.login!.id!,
      searchCtrl.text,
      "${_markerPosition.latitude},${_markerPosition.longitude}",
      noteCtrl.text,
    );
  }
}
