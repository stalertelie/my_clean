// ignore_for_file: non_constant_identifier_names, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/exceptions/current-user-exception.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/account_tab/components/outlined_input.dart';
import 'package:my_clean/pages/account_tab/profile_view_fragment.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';

class ProfileDetailsScreen extends StatefulWidget {
  ProfileDetailsScreen({Key? key, required this.user}) : super(key: key);

  User? user;

  @override
  ProfileDetailsScreenState createState() => ProfileDetailsScreenState();
}

class ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final CurrentUserApi currentUserApi = Ioc().use('currentUserApi');

  bool _gettingInfo = false;
  bool _savingInfo = false;
  bool _changed = false;
  User? _currentUserInfos;
  late AppProvider _appProvider;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  List<TextEditingController>? _listOfControllers;

  get onPressed => null;

  @override
  void initState() {
    _setupControllers();

    _getUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    _tearDownControllers();
    super.dispose();
  }

  void _setupControllers() {
    _listOfControllers = [
      _firstNameController,
      _lastNameController,
      _emailController,
      _phoneController,
    ];

    for (var e in _listOfControllers!) {
      e.addListener(_checkAndSetChanged);
    }
  }

  void _tearDownControllers() {
    _listOfControllers!.map((e) {
      e.removeListener(_checkAndSetChanged);
      e.dispose();
    });
  }

  void _checkAndSetChanged() {
    setState(() {
      _changed = _hasChanged;
    });
  }

  bool get _hasChanged {
    if (_currentUserInfos == null) {
      return false;
    }

    if (_currentUserInfos!.prenoms != _firstNameController.text ||
        _currentUserInfos!.nom != _lastNameController.text ||
        _currentUserInfos!.phone != _phoneController.text ||
        _currentUserInfos!.email != _emailController.text) {
      return true;
    }
    return false;
  }

  _getUserInfo() async {
    try {
      setState(() {
        _gettingInfo = true;
      });
      final User user =
          await currentUserApi.getCurrentUser(widget.user!.id!.substring(7));
      setState(() {
        _gettingInfo = false;
        _currentUserInfos = user;
        _updateControllersWithNewInfo(user);
      });
    } on CurrentUserException catch (exception) {
      _showDialog(exception.message);
      setState(() {
        _gettingInfo = false;
      });
    }
  }

  _saveUserInfo() async {
    FocusScope.of(context).focusedChild!.unfocus();

    try {
      setState(() {
        _savingInfo = true;
      });
      final User newUserInfo = _currentUserInfos!.clone(
          prenoms: _firstNameController.text,
          nom: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text);

      final User user = await currentUserApi.updateCurrentUserInfo(
          newUserInfo, widget.user!.id!.substring(7));
      UtilsFonction.saveData(AppConstant.USER_INFO, jsonEncode(user));
      _appProvider.updateConnectedUSer(user);
      setState(() {
        _changed = false;
        _savingInfo = false;
        _currentUserInfos = user;
        _updateControllersWithNewInfo(user);
      });
      Navigator.pop(context);
    } on CurrentUserException catch (exception) {
      _showDialog(exception.message);
      setState(() {
        _savingInfo = false;
      });
    }
  }

  _updateControllersWithNewInfo(User? userInfo) {
    _firstNameController.text = userInfo!.prenoms.toString();
    _lastNameController.text = userInfo.nom.toString();
    _phoneController.text = userInfo.phone.toString();
    _emailController.text = userInfo.email.toString();
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
    return const ProfileViewFragment();
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: <Widget>[
                  OutlinedInput(
                      controller: _firstNameController,
                      labelText: AppLocalizations.current.firstNameFieldLabel,
                      hintText: 'John'),
                  const SizedBox(height: 24),
                  OutlinedInput(
                      controller: _lastNameController,
                      labelText: AppLocalizations.current.lastNameFieldLabel,
                      hintText: 'Doe'),
                  const SizedBox(height: 24),
                  OutlinedInput(
                      controller: _phoneController,
                      labelText: AppLocalizations.current.phone,
                      hintText: 'John Doe Co. Ltd.'),
                  const SizedBox(height: 24),
                  OutlinedInput(
                      controller: _emailController,
                      labelText: "E-mail",
                      hintText: 'johndoe@email.com'),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Builder(
              builder: (context) => _Button(
                  text: AppLocalizations.current.goOn,
                  onPressed: () {
                    _changed ? _saveUserInfo() : null;
                  },
                  loading: _savingInfo)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: TabAppBar(titleProp: '', context: context, showBackButton: true),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildProfile(),
            Expanded(
              child:
                  _gettingInfo ? Center(child: Loader(size: 50)) : _buildForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button(
      {Key? key,
      required this.text,
      this.loading = false,
      required this.onPressed})
      : super(key: key);

  final String text;
  final bool loading;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43.0,
      width: 319.0,
      child: TextButton(
          onPressed: () {
            onPressed();
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF41ACEF)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (loading) ...[
                Loader(size: 20, color: const Color(0xFFFAF7F2)),
                const SizedBox(width: 10),
              ],
              Text(text.toUpperCase(),
                  style: const TextStyle(
                      color: Color(0xFFFAF7F2),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          )),
    );
  }
}
