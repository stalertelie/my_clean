import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/booking_tarification.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/booking/booking_bloc.dart';
import 'package:my_clean/pages/booking/booking_sucess_page.dart';
import 'package:my_clean/pages/booking/search_bloc.dart';
import 'package:my_clean/pages/booking/search_page.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingScreen extends StatefulWidget {
  final Services service;

  BookingScreen({Key? key, required this.service}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {


  TextEditingController searchCtrl = TextEditingController();

  late final MapController mapController;
  LatLng _markerPosition = LatLng(51.5, -0.09);

  final BookingBloc _bloc = BookingBloc();

  late ListProvider _listProvider;
  late AppProvider _appProvider;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? frequenceValue;

  Feature? _currentFeature;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
    getCurrentLocation();
    if (widget.service.tarifications != null) {
      for (var element in widget.service.tarifications!) {
        _bloc.addTarification(element, 0);
      }
    }

    _bloc.loadingSubject.listen((value) {
      if(value != null && value.message == MessageConstant.booking_ok){
        GetIt.I<AppServices>().messengerGlobalKey!.currentState!.clearSnackBars();
        Future.delayed(const Duration(seconds: 1),(){
          UtilsFonction.NavigateAndRemoveRight(context, BookingResultScreen());
        });
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    _appProvider = Provider.of<AppProvider>(context);
    return Builder(
      builder: (context) {
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
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            center: LatLng(51.5, -0.09),
                            zoom: 13.0,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                              attributionBuilder: (_) {
                                return Text("© Novate Digitale 2021 ");
                              },
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: _markerPosition,
                                  builder: (ctx) => Container(
                                    child: Icon(FontAwesomeIcons.mapPin),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                                  onTap: ()=> showSearhPage(context),
                                  child: TextField(
                                    controller: searchCtrl,
                                    enabled: false,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        prefixIcon: Icon(FontAwesomeIcons.mapMarkerAlt)),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,color: Colors.black,
                              ),
                              SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: StreamBuilder<List<TarificationObject>>(
                                    stream: _bloc.tarificationsStream,
                                    builder: (context, snapshot) {
                                      return snapshot.hasData && snapshot.data != null
                                          ? Column(
                                        children: snapshot.data!
                                            .map((e) => tarificationITem(e))
                                            .toList(),
                                      )
                                          : Container();
                                    }),
                              ),
                              Divider(
                                thickness: 1,color: Colors.black,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "FREQUENCE DE LA PRESTATION".text.size(18).fontFamily("SFPro").bold.make(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: _listProvider.frequenceList
                                          .map((e) => frequenceItem(e))
                                          .toList(),
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
                                          if (_bloc.tarificationsSubject.value.indexWhere(
                                                  (element) => element.quantity! > 0) ==
                                              -1) {
                                            GetIt.I<AppServices>().showSnackbarWithState(Loading(
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
                                        padding: const EdgeInsets.symmetric(vertical: 30),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            "RESERVER".text.fontFamily("SFPro").size(18).bold.white.make(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(color: Colors.black,)
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
                          Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                            IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ))
                          ],),
                          const SizedBox(height: 20,),
                          Hero(
                              tag: widget.service.id.toString(),
                              child: Text(widget.service.title!.toUpperCase(), style:  GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25),))
                        ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
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

  Widget tarificationITem(TarificationObject tarificationObject) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tarificationObject.tarifications!.unite!.text.fontFamily("SFPro").bold.make(),
          Row(
            children: [
              tarificationObject.quantity!.text
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
                  InkWell(
                      onTap: () => _bloc.addTarification(
                          tarificationObject.tarifications!, -1),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Center(child: Icon(Icons.remove)),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                      )),
                  InkWell(
                    onTap: () => _bloc.addTarification(
                        tarificationObject.tarifications!, 1),
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
          )
        ],
      ),
    );
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void getCurrentLocation() async {
    Position position = await _determinePosition();
    print(position);
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

  void showSearhPage(BuildContext ctx){
    _scaffoldKey.currentState!.showBottomSheet((context) => SearchPage(callBack: (Feature feature){
      print("yyyy");
      Navigator.of(context).pop();
      _currentFeature = feature;
      searchCtrl.text = feature.properties!.name!;
      _markerPosition = LatLng(feature.geometry!.coordinates!.last,feature.geometry!.coordinates!.first);
      _animatedMapMove(_markerPosition,15);
      setState(() {

      });
    },));
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
                            "Duration".text.bold.make(),
                            SizedBox(
                              width: 50,
                            ),
                            "${_listProvider.frequenceList != null && _listProvider.frequenceList.isNotEmpty && frequenceValue != null ? _listProvider.frequenceList.firstWhere((element) => element.id == frequenceValue).label : ""}, 4 hours".text.make(),
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
                            _appProvider.login!.commune!.text.make(),
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
                        Row(
                          children: [
                            "Montant a payer".text.bold.make(),
                            SizedBox(
                              width: 50,
                            ),
                            "FCFA ${UtilsFonction.formatMoney(_bloc.tarificationsSubject.value.fold(0, (previous, element) => (previous) + (element.quantity ?? 0) * element.tarifications!.prix!))}"
                                .text
                                .size(18)
                                .bold
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
                    WidgetTemplate.getActionButtonWithIcon(
                        callback: (){
                          print("icicic");
                          bookNow();
                        }, title: "VALIDER"),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ));
  }

  bookNow(){
    Navigator.of(context).pop();
    _bloc.book(_appProvider.login!.id!, frequenceValue, "${_markerPosition.latitude},${_markerPosition.longitude}");
  }
}
