import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/components/select_language_item.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/main.dart';
import 'package:my_clean/pages/home/home_page.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({Key? key}) : super(key: key);

  @override
  ChooseLanguageScreenState createState() => ChooseLanguageScreenState();
}

class ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final RootBLoc _bLoc = RootBLoc();
  String? selectedLanguage = 'fr';
  String _currentLocale = DEFAULT_LOCALE;

  @override
  void initState() {
    getCurrentLocale();
    super.initState();
  }

  getCurrentLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString('locale');

    setState(() {
      _currentLocale = locale ?? DEFAULT_LOCALE;
    });
    if (locale != null && locale.toUpperCase() == "FR") {
      setState(() {
        selectedLanguage = 'fr';
      });
    }
    if (locale != null && locale.toUpperCase() == "EN") {
      setState(() {
        selectedLanguage = 'en';
      });
    }
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

  void _goToHome() {
    _toggleBottomNavigator(true);
    _bLoc.switchToPage(0);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
      (Route<dynamic> route) => false,
    );
  }

  _setLanguage(String locale) async {
    final Locale myLocale = Locale(locale);
    await AppLocalizations.load(myLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
  }

  _chooseLanguage(String locale) {
    _setLanguage(locale);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChooseLanguageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _toggleBottomNavigator(false);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TabAppBar(titleProp: '', context: context),
      body: Container(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 5, right: 17, left: 17),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.current.chooseYourLanguage,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.00),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.00),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            title: const Text('Français',
                                style: TextStyle(
                                    fontSize: 16.00,
                                    fontWeight: FontWeight.w500)),
                            leading: Radio<String>(
                              activeColor: colorBlueLight,
                              value: 'fr',
                              groupValue: selectedLanguage,
                              onChanged: (String? value) {
                                _chooseLanguage(value.toString());
                                setState(() {
                                  selectedLanguage = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text(
                              'English',
                              style: TextStyle(
                                  fontSize: 16.00, fontWeight: FontWeight.w500),
                            ),
                            leading: Radio<String>(
                              activeColor: colorBlueLight,
                              value: 'en',
                              groupValue: selectedLanguage,
                              onChanged: (String? value) {
                                _chooseLanguage(value.toString());
                                setState(() {
                                  selectedLanguage = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            contextProp: context,
                            onPressedProp: () {
                              _goToHome();
                            },
                            textProp: AppLocalizations.current.goOn))))
          ],
        ),
      ),
    );
  }
}
