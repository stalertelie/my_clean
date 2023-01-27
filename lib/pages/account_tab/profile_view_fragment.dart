import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/exceptions/current-user-exception.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';

class ProfileViewFragment extends StatefulWidget {
  const ProfileViewFragment({Key? key}) : super(key: key);

  @override
  _ProfileViewFragmentState createState() => _ProfileViewFragmentState();
}

class _ProfileViewFragmentState extends State<ProfileViewFragment> {
  User? _currentUserInfos;
  String _fullName = '';
  String _phoneNumber = '';
  final CurrentUserApi currentUserApi = Ioc().use('currentUserApi');

  bool _gettingProfileDetails = false;
  @override
  void initState() {
    _getUserInfos();
    super.initState();
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

  Future<User?> getUserInfos() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;

    if (user != null) {
      try {
        final User currentUser =
            await currentUserApi.getCurrentUser(user.id!.substring(7));
        return currentUser;
      } on CurrentUserException catch (exception) {
        _showDialog(exception.message);
      } catch (_) {
        _showDialog(_.toString());
      }
    }

    return null;
  }

  _getUserInfos() async {
    setState(() {
      _gettingProfileDetails = true;
    });
    final User? currentUserInfo = await getUserInfos();
    final String fullName = currentUserInfo != null
        ? '${currentUserInfo.prenoms} ${currentUserInfo.nom}'
        : '';
    final String phoneNumber = currentUserInfo?.phone != null
        ? '+225' + currentUserInfo!.phone.toString()
        : '';
    setState(() {
      _gettingProfileDetails = false;
      _currentUserInfos = currentUserInfo;
      _fullName = fullName;
      _phoneNumber = phoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      //height: ,
      color: const Color(colorDefaultService),
      child: _gettingProfileDetails ? _buildLoadingScreen() : _buildProfile(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(child: Loader(size: 50));
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildImagePortion(),
          _currentUserInfos != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNamePortion(),
                      _buildPhoneNumberPortion(),
                    ],
                  ),
                )
              : Text(AppLocalizations.current.youAreNotLogged,
                  style: TextStyle(
                    color: Colors.redAccent.shade400,
                  )),
        ],
      ),
    );
  }

  Widget _buildImagePortion() {
    return SizedBox(
      width: 60,
      height: 60,
      child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SvgPicture.asset('images/icons/profil_placeholder.svg'),
            ),
            /*Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {},
                child: const Icon(Icons.add_circle,
                    size: 14, color: colorBlueLight),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildNamePortion() {
    return Text(
      _fullName,
      style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: 0.5,
          color: Color(0xFF333333)),
    );
  }

  Widget _buildPhoneNumberPortion() {
    return Text(
      _phoneNumber,
      style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: 0.5,
          color: Color(0xFF333333)),
    );
  }
}
