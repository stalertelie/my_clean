import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/pages/booking/booking_profondeur_page.dart';
import 'package:my_clean/pages/home/home_bloc.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc _bloc = HomeBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.mapMarkerAlt,color: Colors.grey.shade500,size: 15,),
              SizedBox(width: 10,),
              "Abidjan".text.gray500.make()
            ],
          ),
          const SizedBox(height: 10,),
          "Bienvenu, Stephane"
              .text
              .size(25)
              .bold
              .color(const Color(colorBlueGray))
              .make(),
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
                                                if(snapshot
                                                    .data![index].title!.toLowerCase().contains("profondeur")){
                                                  UtilsFonction.NavigateToRoute(
                                                      context,
                                                      BookingProfondeurScreen(
                                                          service: snapshot
                                                              .data![index]));
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "Bientôt disponible",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      //backgroundColor: Colors.red,
                                                      //textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }

                                              }
                                                  ,
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
                  visible: !service.title!.toLowerCase().contains("profondeur"),
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
