// ignore_for_file: non_constant_identifier_names, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/inputs/input_field.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/exceptions/current-user-exception.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final CurrentUserApi currentUserApi = Ioc().use('currentUserApi');

  bool _savingInfo = false;

  late AppProvider _appProvider;

  final _formKey = GlobalKey<FormState>();

  String oldPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  onChangedOldPassword(String text) {
    oldPassword = text;
  }

  onChangedNewPassword(String text) {
    newPassword = text;
  }

  onChangedConfirmPassword(String text) {
    confirmPassword = text;
  }

  _updatePassword() async {
    // FocusScope.of(context).focusedChild!.unfocus();

    try {
      setState(() {
        _savingInfo = true;
      });

      final res = await currentUserApi.updatePassword(oldPassword, newPassword);
      if (res == true) {
        setState(() {
          _savingInfo = false;
        });
        _showMessage("Succès");
        Navigator.of(context).pop();
      }
    } on CurrentUserException catch (exception) {
      _showDialog(exception.message);
      setState(() {
        _savingInfo = false;
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

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InputField(
                          initialValue: "",
                          inputType: TextInputType.text,
                          label: "Ancien mot de passe",
                          labelText: "Ancien mot de passe",
                          onChanged: onChangedOldPassword,
                          obscureText: true,
                          showErrorMessage: true),
                      const SizedBox(height: 24),
                      InputField(
                          initialValue: "",
                          inputType: TextInputType.text,
                          label: "Nouveau mot de passe",
                          labelText: "Nouveau mot de passe",
                          onChanged: onChangedNewPassword,
                          obscureText: true,
                          showErrorMessage: true),
                      const SizedBox(height: 24),
                      InputField(
                          initialValue: "",
                          inputType: TextInputType.text,
                          label: "Confirmation du mot de passe",
                          labelText: "Confirmation du mot de passe",
                          onChanged: onChangedConfirmPassword,
                          showErrorMessage: true,
                          obscureText: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Builder(
                            builder: (context) => _Button(
                                text: AppLocalizations.current.goOn,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _updatePassword();
                                  }
                                },
                                loading: _savingInfo)),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: TabAppBar(
          titleProp: 'Changer le mot de passe',
          context: context,
          showBackButton: true),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // _buildProfile(),
            Expanded(
              child: _buildForm(),
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
