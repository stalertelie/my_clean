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

class BookingClimatiseurScreen extends StatefulWidget {
  final Services service;

  const BookingClimatiseurScreen({Key? key, required this.service})
      : super(key: key);

  @override
  BookingClimatiseurScreenState createState() =>
      BookingClimatiseurScreenState();
}

class BookingClimatiseurScreenState extends State<BookingClimatiseurScreen>
    with TickerProviderStateMixin {
  TextEditingController searchCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  TextEditingController numberCtrl = TextEditingController();

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
  String? selectedClimatiseur = "Entretien simple";

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
      _bloc.setTarificationRoot(widget.service.tarifications!
          .map((e) => TarificationObjectRoot(
              id: e.id!.toString(),
              libelle: e.label!,
              list:
                  [TarificationObject(quantity: 0, tarifications: e)].toList()))
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
      return Scaffold(
        backgroundColor: Color(colorDefaultService),
        key: _scaffoldKey,
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.current.chooseSection
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Color(colorPrimary),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<List<Price>>(
                              stream: _bloc.simpleTarificationStream,
                              builder: (context, snapshot) {
                                return (snapshot.hasData &&
                                        snapshot.data != null
                                    ? Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: snapshot.data!
                                              .mapIndexed<Widget>((e, idx) =>
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Stack(
                                                        children: [
                                                          Column(
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    e.label!
                                                                        .toCapitalized(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                  Radio<String>(
                                                                    activeColor:
                                                                        Color(
                                                                            0XFF01A6DC),
                                                                    value: e
                                                                        .label!,
                                                                    groupValue:
                                                                        selectedClimatiseur,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        selectedClimatiseur =
                                                                            value;
                                                                        tarification =
                                                                            e;
                                                                        tarificationId =
                                                                            idx;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              tarificationITem(
                                                                  e, idx)
                                                            ],
                                                          ),
                                                          Positioned(
                                                              top: 0,
                                                              left: 0,
                                                              child: selectedClimatiseur !=
                                                                      e.label
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            "icic");
                                                                        setState(
                                                                            () {
                                                                          selectedClimatiseur =
                                                                              e.label;
                                                                          tarification =
                                                                              e;
                                                                          tarificationId =
                                                                              idx;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            300,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration: BoxDecoration(
                                                                            color: selectedClimatiseur != null && selectedClimatiseur == e.label
                                                                                ? Colors.transparent
                                                                                : Colors.white.withOpacity(0.6)),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          10,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      decoration: BoxDecoration(
                                                                          color: selectedClimatiseur != null && selectedClimatiseur == e.label
                                                                              ? Colors.transparent
                                                                              : Colors.white.withOpacity(0.6)),
                                                                    ))
                                                        ],
                                                      )))
                                              .toList(),
                                        ),
                                      )
                                    : Container());
                              },
                            ),
                            const SizedBox(
                              height: 25,
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
                            /*AppLocalizations
                                .current.whenDoYouWantTheExecution.text
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
                                  border:
                                      Border.all(color: Color(colorBlueGray)),
                                  color: Colors.grey.shade500),
                              child: Center(
                                child: Text("Service ponctuel",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),*/
                            const SizedBox(
                              height: 10,
                            ),
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
                                        "Le  ${UtilsFonction.formatDate(dateTime: snapshot.data!, format: "EEE dd MMM H:m")}"
                                            .text
                                            .bold
                                            .size(18)
                                            .color(Color(0XFF01A6DC))
                                            .make())
                                : Container();
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomButton(
            contextProp: context,
            onPressedProp: () {
              if (_appProvider.login == null) {
                UtilsFonction.NavigateToRoute(
                    context,
                    LoginScreen(
                      toPop: true,
                    ));
              } else {
                if (!_bloc.bookingDateSubject.hasValue) {
                  GetIt.I<AppServices>().showSnackbarWithState(Loading(
                      hasError: true,
                      message: AppLocalizations.current.dateError));
                  return;
                }
                if (searchCtrl.text.isEmpty) {
                  GetIt.I<AppServices>().showSnackbarWithState(Loading(
                      hasError: true,
                      message: AppLocalizations.current.adressError));
                  return;
                }
                if (!_bloc.bookingDateSubject.hasValue) {
                  GetIt.I<AppServices>().showSnackbarWithState(Loading(
                      hasError: true,
                      message: AppLocalizations.current.dateError));
                  return;
                }
                if (_bloc.totalSubject.value == 0) {
                  GetIt.I<AppServices>().showSnackbarWithState(Loading(
                      hasError: true,
                      message: AppLocalizations.current.serviceError));
                  return;
                }
                showRecapSheet();
              }
            },
            textProp: AppLocalizations.current.order.toUpperCase()),
      );
    });
  }

  Widget tarificationITem(Price price, int rootId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          'Nombre'.toUpperCase().text.size(18).bold.fontFamily("SFPro").make(),
          const SizedBox(
            width: 20,
          ),
          Row(
            children: [
              price.quantity!.text
                  .size(18)
                  .bold
                  .fontFamily("SFPro")
                  .color(const Color(0XFF01A6DC))
                  .make(),
              const SizedBox(
                width: 50,
              ),
              InkWell(
                  onTap: () => _bloc.addTarificationSimplyAirCondition(
                      price, -1,
                      rootId: rootId),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Center(child: Icon(Icons.remove)),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: price.quantity! > 0
                                ? Colors.grey
                                : Colors.grey.shade300)),
                  )),
              InkWell(
                onTap: () => _bloc.addTarificationSimplyAirCondition(price, 1,
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
