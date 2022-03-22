// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/account_tab/change_language_screen.dart';
import 'package:my_clean/pages/account_tab/profile_details_screen.dart';
import 'package:my_clean/pages/account_tab/profile_view_fragment.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/services/booking_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/services/safe_secure_storage.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart' as share_link;

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  String APP_VERSION = "0.0.0";
  RootBLoc _bLoc = RootBLoc();

  final String downloadLink =
      "https://play.google.com/store/apps/details?id=com.novate.my_clean";

  final BookingApi bookingApi = Ioc().use('bookingApi');
  bool _gettingProfileDetails = false;

  User? _currentUserInfos;

  @override
  void initState() {
    _getAppVersion();
    _getUserInfos();
    super.initState();
  }

  _getAppVersion() async {
    try {
      final response = await bookingApi.getAppVersion();
      setState(() {
        APP_VERSION = response;
      });
    } catch (exception) {
      setState(() {
        _showDialog(exception.toString());
      });
    }
  }

  _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: message);
      },
    );
  }

  Widget _buildProfile() {
    return const ProfileViewFragment(
        // currentUserApi: widget.currentUserApi,
        // refreshIndex: _refreshIndex,
        );
  }

  _navigateToScreen(Widget Function(BuildContext context) screenBuilder,
      {Object? routeArgument}) async {
    await Navigator.of(context).push(MaterialPageRoute(
        builder: screenBuilder,
        settings: RouteSettings(arguments: routeArgument)));
  }

  _navigateToProfileDetailsScreen() =>
      _navigateToScreen((context) => ProfileDetailsScreen(
            user: _currentUserInfos,
          ));

  _navigateToChangeLanguageScreen() =>
      _navigateToScreen((context) => const ChangeLanguageScreen());

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final SafeSecureStorage storage = Ioc().use('secureStorage');

    await storage.deleteAll();
    await prefs.clear();
    _bLoc.switchToPage(5);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const RootPage()),
      (Route<dynamic> route) => false,
    );
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

  Future<User?> getUserInfos() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;
    return user;
  }

  _getUserInfos() async {
    setState(() {
      _gettingProfileDetails = true;
    });
    final User? currentUserInfo = await getUserInfos();
    setState(() {
      _gettingProfileDetails = false;
      _currentUserInfos = currentUserInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _toggleBottomNavigator(true);
    });
    return Scaffold(
      backgroundColor: const Color(colorDefaultService),
      appBar: TabAppBar(
          titleProp: AppLocalizations.current.myAccount,
          context: context,
          fontWeight: FontWeight.bold,
          backgroundColor: const Color(colorDefaultService)),
      body: Container(
        color: const Color(colorDefaultService),
        child: Column(
          children: <Widget>[
            _buildProfile(),
            _buildMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return Expanded(
      child: _gettingProfileDetails ? _buildLoading() : _buildOptions(),
    );
  }

  Widget _buildLoading() {
    return Center(child: Loader(size: 50));
  }

  Widget _buildOptions() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildOption(
              icon: Icons.account_circle,
              text: AppLocalizations.current.profileDetailsLabel,
              onTap: () {
                if (_currentUserInfos != null) {
                  _navigateToProfileDetailsScreen();
                }
              },
              status: _currentUserInfos != null
                  ? null
                  : AppLocalizations.current.disconnected),
          _buildOption(
              icon: Icons.language,
              text: AppLocalizations.current.changeLanguage,
              onTap: _navigateToChangeLanguageScreen),
          _buildOption(
              icon: Icons.security,
              text: AppLocalizations.current.changePassword,
              onTap: () {},
              status: AppLocalizations.current.comingSoon),
          _buildOption(
            icon: Icons.share,
            text: AppLocalizations.current.shareApp,
            onTap: () async {
              await share_link.Share.share(
                  AppLocalizations.current.appDownloadLink(downloadLink));
            },
          ),
          _buildOption(
              icon: Icons.privacy_tip,
              text: AppLocalizations.current.conditionsOfUse,
              onTap: () {},
              status: AppLocalizations.current.comingSoon),
          _buildOption(
              icon: Icons.exit_to_app,
              text: AppLocalizations.current.logout,
              onTap: () {
                if (_currentUserInfos != null) {
                  _logout();
                }
              },
              status: _currentUserInfos != null
                  ? null
                  : AppLocalizations.current.disconnected),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Version $APP_VERSION"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOption(
      {required IconData icon,
      required String text,
      String? status,
      Function? onTap}) {
    return Material(
      color: Colors.transparent,
      child: Column(children: <Widget>[
        InkWell(
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
          child: SizedBox(
            height: 64,
            child: Row(children: <Widget>[
              const SizedBox(width: 23.9),
              Icon(icon, size: 24, color: Colors.black),
              const SizedBox(width: 10.1),
              Text(text,
                  style: const TextStyle(
                      fontFamily: 'Roboto', fontSize: 16, letterSpacing: 0.5)),
              if (status != null && status.isNotEmpty) ...[
                Spacer(),
                Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4FD),
                    border: Border.all(color: const Color(0xFF41AC)),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: const TextStyle(
                          color: Color(0xFF41ACEF), fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 19.55)
              ],
            ]),
          ),
        ),
        const Divider(color: Color.fromRGBO(0, 0, 0, 0.12)),
      ]),
    );
  }
}
