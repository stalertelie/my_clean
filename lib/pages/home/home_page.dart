import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ioc/ioc.dart';
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
import 'package:my_clean/pages/home/home_header.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:my_clean/extensions/extensions.dart';

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
    return Scaffold(
      backgroundColor: const Color(0XFFF3F3F8),
      appBar: AppBar(backgroundColor: const Color(colorPrimary),elevation: 0,),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(''),
              pinned: false,
              floating: true,
              backgroundColor: const Color(0XFFF3F3F8),
              flexibleSpace: HomeHeader(login: _appProvider.login,),
              expandedHeight: 300,
              stretch: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: "Services".text.bold.size(45).black.make(),
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
                              ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                            .contains(
                                            "profondeur") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains("deep")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingProfondeurScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains("vehicule") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains("cars")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingVehicleScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains("matelas") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains("mattress")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingMattressScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains("tapis") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains(
                                                " carpet cleaning")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingCarpetScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains(
                                            "climatiseur") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains(
                                                "conditioner")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingClimatiseurScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains(
                                            "chaise, fauteuils et canapes") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains(
                                                "chairs, armchairs and carpet")) {
                                          UtilsFonction.NavigateToRoute(
                                              context,
                                              BookingSofaScreen(
                                                  service: snapshot
                                                      .data![index]));
                                        } else if (snapshot
                                            .data![index].title!
                                            .toLowerCase()
                                            .contains(
                                            "désinfection") ||
                                            snapshot.data![index].title!
                                                .toLowerCase()
                                                .contains(
                                                "disinfection")) {
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
                          ),
                              )
                              : WidgetTemplate.getEmptyBox(
                              message:
                              "Aucun service disponible pour le moment");
                        })
                        : const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget ServiceItem({required Services service}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              height: 150,
              width: double.maxFinite,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: UtilsFonction.CachedImage(service.contentUrl ?? ""))),
        ),
        const SizedBox(height: 5,),
        Text(service.title?.toTitleCase() ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)
      ],
    );
  }
}
