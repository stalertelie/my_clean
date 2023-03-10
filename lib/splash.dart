import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    super.initState();
    //setup();
    initLanguage();
    Future.delayed(
        const Duration(seconds: 7),
        () => {
              UtilsFonction.getData(AppConstant.USER_INFO).then((value) {
                if (value != null) {
                  User user = User.fromJson(jsonDecode(value));
                  GetIt.I<AppServices>().setUSer(user);
                  UtilsFonction.NavigateAndRemoveRight(context, RootPage());
                } else {
                  UtilsFonction.NavigateAndRemoveRight(
                      context,
                      LoginScreen(
                        toPop: false,
                      ));
                }
              })
            });
  }

  void initLanguage() async {
    final Locale newLocale = const Locale('fr');
    await AppLocalizations.load(newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', 'fr');

    GetIt.I<AppServices>().setLang('fr');
  }

  @override
  Widget build(BuildContext context) {
    _listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: double.maxFinite,
              child: Image.asset(
                "images/others/splash.png",
                fit: BoxFit.cover,
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
