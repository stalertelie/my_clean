import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_clean/components/select_language_item.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/pages/home/home_page.dart';
import 'package:my_clean/pages/onboarding/choose_language_screen.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/pages/root/root_page.dart';

class ChooseCountryScreen extends StatefulWidget {
  const ChooseCountryScreen({Key? key}) : super(key: key);

  @override
  ChooseCountryScreenState createState() => ChooseCountryScreenState();
}

class ChooseCountryScreenState extends State<ChooseCountryScreen> {
  final RootBLoc _bLoc = RootBLoc();
  @override
  void initState() {
    super.initState();
  }

  void _toggleBottomNavigator(bool show) async {
    final RootPageState? bottomTabNavigator =
        context.findAncestorStateOfType<RootPageState>();
    if (bottomTabNavigator != null && show) {
      bottomTabNavigator.showBottomTabNavigator();
    } else if (bottomTabNavigator != null && !show) {
      bottomTabNavigator.hideBottomTabNavigator();
    }
  }

  void navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChooseLanguageScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _toggleBottomNavigator(false);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TabAppBar(titleProp: '', context: context),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2,
              child: Image.asset(
                mainLogo,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                AppLocalizations.current.chooseYourCountry,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 20,
                  left: 40.0,
                  right: 40.0),
              child: Center(
                child: SelectLanguageItem(
                  context: context,
                  onTap: navigate,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
