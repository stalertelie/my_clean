import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/home/home_page.dart';
import 'package:my_clean/pages/root/root_bloc.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {


  final GlobalKey<ScaffoldState> _key = GlobalKey();

  final List<Widget> _listPage = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  final List<DrawerItem> _listDrawerConnectedPages = [
    DrawerItem(title: "Editer profile",page: Container(),icon: const Icon(FontAwesomeIcons.userEdit)),
    DrawerItem(title: "Notifications",page: Container(),icon: const Icon(FontAwesomeIcons.bell)),
    DrawerItem(title: "Avis",page: Container(),icon: SvgPicture.asset("images/icons/edit_profil.svg")),
    DrawerItem(title: "Termes et conditions",page: Container(),icon: SvgPicture.asset("images/icons/feedback.svg")),
    DrawerItem(title: "Partager",page: Container(),icon: Icon(Icons.share_outlined)),
  ];

  final List<DrawerItem> _listDrawerNoConnectedPages = [
    DrawerItem(title: "Avis",page: Container(),icon: SvgPicture.asset("images/icons/edit_profil.svg")),
    DrawerItem(title: "Termes et conditions",page: Container(),icon: SvgPicture.asset("images/icons/feedback.svg")),
    DrawerItem(title: "Partager",page: Container(),icon: Icon(Icons.share_outlined)),
  ];

  RootBLoc _bLoc = new RootBLoc();

  bool isInitial = true;

  late AppProvider _appProvider;





  @override
  void initState() {
    super.initState();
    _bLoc.drawerIndexSubject.listen((value) {
      if(value == 0 && !isInitial){
        _bLoc.switchToPage(3);
      }else if(value == 2){
        _bLoc.switchToPage(1);
      } else if(value ==3){
        _bLoc.switchToPage(2);
      }
    });

    Future.delayed(Duration(seconds: 2),(){
      setState(() {
        isInitial = false;
      });
    });

    Future.delayed(const Duration(milliseconds: 500),(){
      UtilsFonction.getData(AppConstant.USER_INFO).then((value){
        if(value != null){
          User user = User.fromJson(jsonDecode(value));
          _appProvider.updateConnectedUSer(user);
        }
      }
      );
    });


  }


  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          leading: Image.asset("images/icons/balai.png"),
          elevation: 0,
          centerTitle: true,
          title: _appProvider.login != null ? Text(_appProvider.login!.nom!) : const Text(""),
          backgroundColor: Colors.white,
          actions: [
            IconButton(onPressed: ()=>_key.currentState!.openEndDrawer(), icon: SvgPicture.asset("images/icons/user-profile.svg"))
          ],
        ),
        body: StreamBuilder<int>(
          stream: _bLoc.pageindexStream,
          builder: (context, snapshot) {
            return _listPage[snapshot.data ?? 0];
          }
        ),
        endDrawer: ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
          child: Drawer(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-45,
                    width: 200,
                  ),
                  Column(
                    children: [
                      Visibility(
                        visible: _appProvider.login != null,
                        child: DrawerHeader(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.account_circle_outlined,size: 70,),
                            "${_appProvider.login != null ? _appProvider.login!.nom : "Veuillez vous connecter"}".text.bold.make(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Location".text.make(),
                                Row(
                                  children: [
                                    "Se deconnecter".text.color(const Color(colorPrimary)).make(),
                                    const SizedBox(width: 10,),
                                    const Icon(Icons.login)
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: (_appProvider.login != null ?  _listDrawerConnectedPages : _listDrawerNoConnectedPages).mapIndexed((e,index) => drawerItemWidget(drawerItem: e,index: index)).toList(),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: StreamBuilder<int>(
          stream: _bLoc.pageindexStream,
          builder: (context, snapshot) {
            return BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Color(colorPrimary),
              unselectedItemColor: Colors.black,
              currentIndex: snapshot.data ?? 0,
              onTap: (index){
                _bLoc.switchToPage(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.search), label: ""),
                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bell), label: ""),
                BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.envelope), label: "",),

              ],
            );
          }
        ),
      ),
    );
  }

  Widget drawerItemWidget({required DrawerItem drawerItem, required int index}){
    return StreamBuilder<int>(
      stream: _bLoc.drawerIndexStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: (){
            _bLoc.switchDrawerIndex(index);
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    drawerItem.icon,
                    SizedBox(width: 40,),
                    drawerItem.title.text.color(Color(colorGrey)).size(15).make(),
                  ],
                ),
                Icon(Icons.keyboard_arrow_right,color: Color(colorGrey),)
              ],
            ),
          ),
        );
      }
    );
  }
}

class DrawerItem {
  String title;
  Widget icon;
  Widget page;

  DrawerItem({required this.title, required this.icon, required this.page});
}
