import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/auth/update_password.dart';
import 'package:my_clean/pages/home/home_header.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ResetPassword extends StatefulWidget {
  final bool? toPop;
  const ResetPassword({Key? key, this.toPop}) : super(key: key);

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _phoneCtrl = TextEditingController();

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
      final res = await currentUserApi.sendVerificationCode(_phoneCtrl.text);
      if (res == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdatePassword(
              phone: _phoneCtrl.text,
            ),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            "Réinitialisation du mot de passe"
                .text
                .fontFamily('SFPro')
                .size(20)
                .bold
                .make(),
            const SizedBox(
              height: 50.0,
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Container(
                              height: 38,
                              child: DropdownButton<String>(
                                value: indicatif,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    indicatif = newValue!;
                                  });
                                },
                                items: <String>[
                                  '+225',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'images/icons/ci_logo.png',
                                          width: 30,
                                        ),
                                      ),
                                      Text(
                                        "(${value})",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                  );
                                }).toList(),
                              ),
                            ),
                            Flexible(
                              child: TextFormField(
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 5),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 1)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 1)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 1)),
                                    labelText: AppLocalizations.current.numTel,
                                    labelStyle: const TextStyle(
                                        color: Color(0XFFBBBBBB),
                                        fontFamily: 'SFPro')),
                                keyboardType: TextInputType.phone,
                                controller: _phoneCtrl,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations
                                        .current.requiredField;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
