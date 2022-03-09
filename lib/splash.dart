import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final getIt = GetIt.instance;

  late ListProvider _listProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //setup();
    Future.delayed(
        const Duration(seconds: 4),
        () => {
              UtilsFonction.NavigateAndRemoveRight(context, RootPage())
            });
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                "images/others/splash.png",
                fit: BoxFit.fill,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height * 2 / 3,
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.7)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 2 / 3 + 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  ZoomIn(child: SvgPicture.asset('images/icons/logitext.svg')),
                ],
              )),
          Positioned(
              top: MediaQuery.of(context).size.height * 2 / 3 + 180,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SlideInLeft(
                      child: "You click, We clean".text.size(15).white.make())
                ],
              ))
        ],
      ),
    );
  }

  void setup() async {
    try {
      getIt.registerSingleton<AppServices>(AppServices());
    } catch (exeption) {
      print(exeption);
    }
  }
}
