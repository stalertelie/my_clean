import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/booking/booking_carpet.dart';
import 'package:my_clean/pages/booking/booking_climatiseur.dart';
import 'package:my_clean/pages/booking/booking_desinfection.dart';
import 'package:my_clean/pages/booking/booking_profondeur_page.dart';
import 'package:my_clean/pages/booking/booking_mattress.dart';
import 'package:my_clean/pages/booking/booking_sofa.dart';
import 'package:my_clean/pages/booking/booking_vehicle.dart';
import 'package:my_clean/pages/home/home_bloc.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc();
  late AppProvider _appProvider;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    final user = await _bloc.getUserInfos();
    _appProvider.updateConnectedUSer(user);
  }

  TextStyle welcomeTextStyle = const TextStyle(
      color: Color(colorBlueGray), fontSize: 25, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                color: Colors.grey.shade500,
                size: 15,
              ),
              const SizedBox(
                width: 10,
              ),
              "Abidjan".text.gray500.make()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _appProvider.login != null
              ? Text(
                  "Bienvenue, " + _appProvider.login!.prenoms.toString(),
                  style: welcomeTextStyle,
                )
              : Text("Bienvenue", style: welcomeTextStyle),
          "Choisir un service"
              .text
              .size(15)
              .color(const Color(colorBlueGray))
              .make(),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: StreamBuilder<Loading>(
                  stream: _bloc.loading,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.loading == false
                        ? StreamBuilder<List<Services>>(
                            stream: _bloc.servicesStream,
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              childAspectRatio: 0.9),
                                      itemBuilder: (context, index) =>
                                          GestureDetector(
                                              onTap: () {
                                                if (snapshot.data![index].title!
                                                    .toLowerCase()
                                                    .contains("profondeur")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingProfondeurScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("vehicule")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingVehicleScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("matelas")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingMattressScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("tapis")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingCarpetScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("climatiseur")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingClimatiseurScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("chaises")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingSofaScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else if (snapshot
                                                    .data![index].title!
                                                    .toLowerCase()
                                                    .contains("desinfection")) {
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingDesinfectionScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "Bientôt disponible",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      //backgroundColor: Colors.red,
                                                      //textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }
                                              },
                                              child: ServiceItem(
                                                  service:
                                                      snapshot.data![index])),
                                      itemCount: snapshot.data!.length,
                                    )
                                  : WidgetTemplate.getEmptyBox(
                                      message:
                                          "Aucun service disponible pour le moment");
                            })
                        : const Center(
                            child: CircularProgressIndicator(),
                          );
                  }))
        ],
      ),
    );
  }

  Widget ServiceItem({required Services service}) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              /*image: DecorationImage(
                  image: NetworkImage(service.contentUrl ?? ""),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken)),*/
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Stack(
              children: [
                Container(
                    height: 150,
                    width: double.maxFinite,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: UtilsFonction.CachedImage(
                            service.contentUrl ?? ""))),
                Visibility(
                  visible: !service.title!
                          .toLowerCase()
                          .contains("profondeur") &&
                      !service.title!.toLowerCase().contains("vehicule") &&
                      !service.title!.toLowerCase().contains("matelas") &&
                      !service.title!.toLowerCase().contains("tapis") &&
                      !service.title!.toLowerCase().contains("climatiseur") &&
                      !service.title!.toLowerCase().contains("chaises") &&
                      !service.title!.toLowerCase().contains("desinfection"),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      height: 150,
                      width: double.maxFinite,
                    ),
                  ),
                )
                /*Hero(
                  tag: service.id.toString(),
                  child: Center(
                    child: service.title!
                        .toUpperCase()
                        .text
                        .center
                        .white
                        .size(15)
                        .bold
                        .make(),
                  ),
                ),*/
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          "Commander".text.color(const Color(colorBlueGray)).size(15).make()
        ],
      ),
    );
  }
}
