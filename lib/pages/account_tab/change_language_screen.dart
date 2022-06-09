import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/account_tab/account_screen.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({Key? key}) : super(key: key);

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _currentLocaleCode = '';
  final RootBLoc _bloc = RootBLoc();

  @override
  void initState() {
    _getLocale();

    super.initState();
  }

  void _getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocaleCode = prefs.getString('locale');

    setState(() {
      _currentLocaleCode = currentLocaleCode!.toLowerCase();
    });
  }

  void _setLanguage(String localeCode) async {
    setState(() {
      _currentLocaleCode = localeCode;
    });

    GetIt.I<AppServices>().setLang(localeCode);

    final Locale newLocale = Locale(localeCode);
    await AppLocalizations.load(newLocale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', localeCode);

    _bloc.switchToPage(0);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
          titleProp: AppLocalizations.current.changeLanguage,
          context: context,
          showBackButton: true),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          _buildBodyDivider(),
          _buildOption(
              text: 'English',
              isSelected: _currentLocaleCode.toLowerCase() == 'en',
              onTap: () {
                _setLanguage('en');
              }),
          _buildOption(
              text: 'Français',
              isSelected: _currentLocaleCode.toLowerCase() == 'fr',
              onTap: () {
                _setLanguage('fr');
              }),
        ]),
      ),
    );
  }

  Widget _buildBodyDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBEC2C4).withOpacity(0.7),
            offset: const Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
    );
  }

  Widget _buildOption({
    required String text,
    required isSelected,
    void Function()? onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black.withOpacity(0.12)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: colorBlueLight)
            ],
          ),
        ),
      ),
    );
  }
}
