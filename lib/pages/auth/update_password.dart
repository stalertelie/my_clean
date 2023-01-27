import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/auth/login_page.dart';
import 'package:my_clean/pages/home/home_header.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class UpdatePassword extends StatefulWidget {
  final String phone;
  const UpdatePassword({Key? key, required this.phone}) : super(key: key);

  @override
  UpdatePasswordState createState() => UpdatePasswordState();
}

class UpdatePasswordState extends State<UpdatePassword> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  late AppProvider _appProvider;

  String indicatif = "+225";

  final _formKey = GlobalKey<FormState>();

  final CurrentUserApi currentUserApi = Ioc().use('currentUserApi');

  bool loader = false;

  @override
  void initState() {
    super.initState();
  }

  void _send() async {
    setState(() {
      loader = true;
    });
    try {
      final res = await currentUserApi.verifyCodeAndUpdatePassword(
          widget.phone, _code.text, _newPassword.text);
      if (res == true) {
        _showMessage("Votre mot de passe a bien été mis à jour");
        UtilsFonction.NavigateAndRemoveRight(context, const LoginScreen());
      }
    } catch (e) {
      setState(() {
        loader = false;
      });
      _showDialog(e.toString());
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

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.current.changePassword,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(colorPrimary),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  child: Container(
                    color: const Color(colorPrimary),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Image.asset(
                          "images/icons/NCBD.png",
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                  clipper: BottomWaveClipper(distance: 150),
                ),
              ],
            ),
            "Saisissez le code qui a été envoyer au ${widget.phone}"
                .text
                .fontFamily('SFPro')
                .size(15.0)
                .make(),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SlideInRight(
                          child: TextFormField(
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            suffixIconConstraints: const BoxConstraints(
                                maxHeight: 15, minWidth: 40),
                            labelText: "Code"),
                        obscureText: true,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        controller: _code,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.current.requiredField;
                          } else
                            return null;
                        },
                      )),
                      const SizedBox(
                        height: 20.0,
                      ),
                      SlideInRight(
                          child: TextFormField(
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1)),
                            suffixIconConstraints: const BoxConstraints(
                                maxHeight: 15, minWidth: 40),
                            labelText: "Nouveau mot de passe"),
                        obscureText: true,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        controller: _newPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.current.requiredField;
                          } else
                            return null;
                        },
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () => {
                          if (_formKey.currentState!.validate()) {_send()}
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: const Color(colorPrimary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            loader
                                ? Loader(size: 15.0, color: Colors.white)
                                : "Envoyer".text.white.size(18).bold.make()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
