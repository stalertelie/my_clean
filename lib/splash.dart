import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';

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
    Future.delayed(const Duration(seconds: 5),
        () => {UtilsFonction.NavigateAndRemoveRight(context, RootPage())});
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0XFF2387A3), Color(0XFF23AEE3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Pulse(
              duration: const Duration(seconds: 10),
              infinite: true,
              child: SvgPicture.asset(
                "images/icons/myclean-logo-vectoriser.svg",
                width: 200,
              )),
        ),
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
