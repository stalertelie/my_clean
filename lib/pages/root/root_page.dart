import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/main.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/account_tab/account_screen.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/booking/command_list.dart';
import 'package:my_clean/pages/home/home_page.dart';
import 'package:my_clean/pages/notification/notification_page.dart';
import 'package:my_clean/pages/onboarding/choose_country_screen.dart';
import 'package:my_clean/pages/onboarding/choose_language_screen.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends State<RootPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  DateTime? _backgroundTime;
  final storage = Ioc().use<FlutterSecureStorage>('secureStorage');
  String? _token = '';

  List<Widget> _listPage = [];

  final List<DrawerItem> _listDrawerConnectedPages = [
    DrawerItem(
        title: "Editer profile",
        page: Container(),
        icon: const Icon(FontAwesomeIcons.userEdit)),
    DrawerItem(
        title: "Notifications",
        page: Container(),
        icon: const Icon(FontAwesomeIcons.bell)),
    DrawerItem(
        title: "Avis",
        page: Container(),
        icon: SvgPicture.asset("images/icons/edit_profil.svg")),
    DrawerItem(
        title: "Termes et conditions",
        page: Container(),
        icon: SvgPicture.asset("images/icons/feedback.svg")),
    DrawerItem(
        title: "Partager", page: Container(), icon: Icon(Icons.share_outlined)),
    DrawerItem(
        title: "Historique commandes",
        page: Container(),
        icon: Icon(Icons.history)),
  ];

  final List<DrawerItem> _listDrawerNoConnectedPages = [
    DrawerItem(
        title: "Avis",
        page: Container(),
        icon: SvgPicture.asset("images/icons/edit_profil.svg")),
    DrawerItem(
        title: "Termes et conditions",
        page: Container(),
        icon: SvgPicture.asset("images/icons/feedback.svg")),
    DrawerItem(
        title: "Partager", page: Container(), icon: Icon(Icons.share_outlined)),
  ];

  RootBLoc _bLoc = RootBLoc();

  bool isInitial = true;

  late AppProvider _appProvider;
  bool _bottomTabNavigatorVisible = true;

  hideBottomTabNavigator() {
    setState(() {
      _bottomTabNavigatorVisible = false;
    });
  }

  showBottomTabNavigator() {
    setState(() {
      _bottomTabNavigatorVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _listPage = [
      HomeScreen(),
      CommandList(
        onServiceRequested: (String? idService) {
          _bLoc.switchToPage(0);
          if (idService != null) {
            GetIt.I<AppServices>().setServicePassedId(idService);
          }
        },
      ),
      const NotificationScreen(),
      const AccountScreen(),
      CommandList(
        onServiceRequested: (String? idService) => {},
      ),
      const ChooseCountryScreen()
    ];
    _bLoc.drawerIndexSubject.listen((value) {
      print(value);
      if (value == 0 && !isInitial) {
        _bLoc.switchToPage(3);
      } else if (value == 2) {
        _bLoc.switchToPage(1);
      } else if (value == 3) {
        _bLoc.switchToPage(2);
      } else if (value == 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CommandList(onServiceRequested: (String? id) {}),
          ),
        );
      }
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isInitial = false;
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      UtilsFonction.getData(AppConstant.USER_INFO).then((value) {
        if (value != null) {
          User user = User.fromJson(jsonDecode(value));
          _appProvider.updateConnectedUSer(user);
        }
      });
    });
    _readToken();
    _initLocale();
    _subscribeAppLifeCycle();
  }

  _logout(context) {
    _bLoc.logout();
    _appProvider.updateConnectedUSer(null);
    _showMessage('Vous êtes bien déconnecté !');
    return Navigator.pop(context);
  }

  _showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  void _initLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString('locale');
    await AppLocalizations.load(Locale(locale ?? DEFAULT_LOCALE));
  }

  Future<void> _readToken() async {
    final prefs = await SharedPreferences.getInstance();
    final longitudePref = prefs.getDouble('longitude');
    // await prefs.remove('longitude');
    // await prefs.remove('latitude');
    if (longitudePref == null) {
      _bLoc.switchToPage(5);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseCountryScreen(),
        ),
      );
    }
  }

  void _subscribeAppLifeCycle() {
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    _unsubscribeAppLifeCycle();
  }

  void _unsubscribeAppLifeCycle() {
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _lockScreenIfNecessary();
    } else if (state == AppLifecycleState.paused) {
      _startLockTimer();
    }
  }

  void _lockScreenIfNecessary() async {
    if (_backgroundTime != null) {
      if (await _isLockNecessary()) {
        // unawaited(
        //     _navigationService.popAllAndNavigateTo(MaterialPageRoute<void>(
        //   builder: (BuildContext context) => PasscodeScreen(),
        // )));
      }
    }
    _backgroundTime = null;
  }

  Future<bool> _isLockNecessary() async {
    final currentTime = DateTime.now();
    final elapsedDuration = currentTime.difference(_backgroundTime!);
    final lockInSeconds = AppConfig.of(context)!.lockInSeconds;

    await _readToken();
    return elapsedDuration.inSeconds > lockInSeconds && _token != null;
  }

  void _startLockTimer() {
    if (_backgroundTime == null) {
      _backgroundTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      body: StreamBuilder<int>(
          stream: _bLoc.pageindexStream,
          builder: (context, snapshot) {
            return _listPage[snapshot.data != null && snapshot.data != 5
                ? snapshot.data!.toInt()
                : 0];
          }),
      // drawer: ClipRRect(
      //   borderRadius: const BorderRadius.only(
      //       bottomRight: Radius.circular(50), topRight: Radius.circular(50)),
      //   child: Drawer(
      //     child: SingleChildScrollView(
      //       child: Stack(
      //         children: [
      //           Container(
      //             height: MediaQuery.of(context).size.height - 45,
      //             width: 200,
      //           ),
      //           Column(
      //             children: [
      //               Visibility(
      //                 visible: _appProvider.login != null,
      //                 child: DrawerHeader(
      //                     child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: <Widget>[
      //                     const Icon(
      //                       Icons.account_circle_outlined,
      //                       size: 70,
      //                     ),
      //                     "${_appProvider.login != null ? _appProvider.login!.prenoms : "Veuillez vous connecter"}"
      //                         .text
      //                         .bold
      //                         .make(),
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         "Location".text.make(),
      //                         TextButton(
      //                             onPressed: () {
      //                               _logout(context);
      //                             },
      //                             child: Row(
      //                               children: const <Widget>[
      //                                 Text(
      //                                   "Se déconnecter",
      //                                   style: TextStyle(
      //                                       color: Color(colorPrimary)),
      //                                 ),
      //                                 SizedBox(
      //                                   width: 10,
      //                                 ),
      //                                 Icon(
      //                                   Icons.logout,
      //                                   color: Colors.black,
      //                                 )
      //                               ],
      //                             ))
      //                       ],
      //                     )
      //                   ],
      //                 )),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Column(
      //                   children: (_appProvider.login != null
      //                           ? _listDrawerConnectedPages
      //                           : _listDrawerNoConnectedPages)
      //                       .mapIndexed((e, index) =>
      //                           drawerItemWidget(drawerItem: e, index: index))
      //                       .toList(),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: _bottomTabNavigatorVisible
          ? StreamBuilder<int>(
              stream: _bLoc.pageindexStream,
              builder: (context, snapshot) {
                return BottomNavigationBar(
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  elevation: 0,
                  backgroundColor: const Color(colorDefaultService),
                  selectedItemColor: const Color(colorBottomBarIcon),
                  unselectedItemColor: Colors.black,
                  currentIndex: snapshot.data ?? 0,
                  iconSize: 20,
                  onTap: (index) {
                    _bLoc.switchToPage(index);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "images/icons/house.svg",
                          width: 30,
                          color: snapshot.data == 0
                              ? const Color(colorBottomBarIcon)
                              : Colors.black,
                        ),
                        label: AppLocalizations.current.home),
                    BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.calendarAlt),
                        label: AppLocalizations.current.myBooking),
                    BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.bell),
                        label: AppLocalizations.current.notifications),
                    BottomNavigationBarItem(
                        icon: const Icon(FontAwesomeIcons.userAlt),
                        label:
                            AppLocalizations.current.myAccount.toCapitalized()),
                  ],
                );
              })
          : null,
    );
  }

  Widget drawerItemWidget(
      {required DrawerItem drawerItem, required int index}) {
    return StreamBuilder<int>(
        stream: _bLoc.drawerIndexStream,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () {
              print(index);
              _bLoc.switchDrawerIndex(index);
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      drawerItem.icon,
                      SizedBox(
                        width: 40,
                      ),
                      drawerItem.title.text
                          .color(Color(colorGrey))
                          .size(15)
                          .make(),
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Color(colorGrey),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class DrawerItem {
  String title;
  Widget icon;
  Widget page;

  DrawerItem({required this.title, required this.icon, required this.page});
}
