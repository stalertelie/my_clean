import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:ioc/ioc.dart';
import 'package:collection/collection.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/booking/booking_carpet.dart';
import 'package:my_clean/pages/booking/booking_cleaning.dart';
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
import 'package:my_clean/services/app_service.dart';
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
      appBar: AppBar(
        backgroundColor: const Color(colorPrimary),
        elevation: 0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text(''),
              pinned: false,
              floating: true,
              backgroundColor: const Color(0XFFF3F3F8),
              flexibleSpace: HomeHeader(
                login: _appProvider.login,
              ),
              expandedHeight: 250,
              stretch: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Services".text.bold.size(45).black.make(),
                  const SizedBox(
                    height: 20,
                  ),
                  "Nettoyage".text.bold.size(25).make()
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<Loading>(
                  stream: _bloc.loading,
                  builder: (context, snapshotLoading) {
                    return snapshotLoading.hasData &&
                            snapshotLoading.data!.loading == false
                        ? StreamBuilder<List<Services>>(
                            stream: _bloc.servicesStream,
                            builder: (context, snapshot) {
                              if (GetIt.I<AppServices>().servicePassedId !=
                                      null &&
                                  snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.isNotEmpty) {
                                print(GetIt.I<AppServices>().servicePassedId);
                                Services? services = snapshot.data!
                                    .firstWhereOrNull((element) =>
                                        element.id!.trim() ==
                                        GetIt.I<AppServices>().servicePassedId);
                                redirectToServiceFromCommand(services);
                              }
                              return snapshot.hasData
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0,
                                                childAspectRatio: 0.8),
                                        itemBuilder: (context, index) =>
                                            GestureDetector(
                                                onTap: () {
                                                  goToServiceDetail(
                                                      snapshot.data![index]);
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

  void redirectToServiceFromCommand(Services? services) async {
    if (services != null) {
      Future.delayed(
          const Duration(milliseconds: 300), () => goToServiceDetail(services));
      GetIt.I<AppServices>().setServicePassedId(null);
    }
  }

  void goToServiceDetail(Services services) {
    if (services.title!.toLowerCase().contains("profondeur") ||
        services.title!.toLowerCase().contains("deep")) {
      UtilsFonction.NavigateToRoute(
          context, BookingProfondeurScreen(service: services));
    } else if (services.title!.toLowerCase().contains("vehicule") ||
        services.title!.toLowerCase().contains("cars")) {
      UtilsFonction.NavigateToRoute(
          context, BookingVehicleScreen(service: services));
    } else if (services.title!.toLowerCase().contains("matelas") ||
        services.title!.toLowerCase().contains("mattress")) {
      UtilsFonction.NavigateToRoute(
          context, BookingMattressScreen(service: services));
    } else if (services.title!.toLowerCase().contains("cleaning") ||
        services.title!.toLowerCase().contains("domicile")) {
      UtilsFonction.NavigateToRoute(
          context, BookingCleaningScreen(service: services));
    } else if (services.title!.toLowerCase().contains("tapis") ||
        services.title!.toLowerCase().contains(" carpet cleaning")) {
      UtilsFonction.NavigateToRoute(
          context, BookingCarpetScreen(service: services));
    } else if (services.title!.toLowerCase().contains("climatiseur") ||
        services.title!.toLowerCase().contains("conditioner")) {
      UtilsFonction.NavigateToRoute(
          context, BookingClimatiseurScreen(service: services));
    } else if (services.title!
            .toLowerCase()
            .contains("chaise, fauteuils et canapes") ||
        services.title!
            .toLowerCase()
            .contains("chairs, armchairs and carpet")) {
      UtilsFonction.NavigateToRoute(
          context, BookingSofaScreen(service: services));
    } else if (services.title!.toLowerCase().contains("désinfection") ||
        services.title!.toLowerCase().contains("disinfection")) {
      UtilsFonction.NavigateToRoute(
          context, BookingDesinfectionScreen(service: services));
    } else {
      Fluttertoast.showToast(
          msg: "Bientôt disponible",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          //backgroundColor: Colors.red,
          //textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget ServiceItem({required Services service}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            //height: 150,
            width: MediaQuery.of(context).size.width - 10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: UtilsFonction.CachedImage(service.contentUrl ?? ""))),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            service.title?.toTitleCase() ?? '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
