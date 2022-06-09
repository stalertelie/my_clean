import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/auth/aut_bloc.dart';
import 'package:my_clean/pages/auth/singup_page.dart';
import 'package:my_clean/pages/home/home_header.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  final bool? toPop;
  const LoginScreen({Key? key, this.toPop}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();

  late AppProvider _appProvider;

  bool _showPass = false;

  String indicatif = "+225";

  final _formKey = GlobalKey<FormState>();

  final AuthBloc _bloc = AuthBloc();

  @override
  void initState() {
    super.initState();

    _bloc.loadingSubject.listen((value) {
      if (value.message == MessageConstant.loginok) {
        GetIt.I<AppServices>()
            .messengerGlobalKey!
            .currentState!
            .clearSnackBars();
        _appProvider.updateConnectedUSer(value.data);
        if (widget.toPop != true) {
          UtilsFonction.NavigateAndRemoveRight(context, RootPage());
        } else {
          Navigator.of(context).pop();
        }
      }
    });
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
                /*SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Connexion"
                            .text
                            .size(25)
                            .bold
                            .color(Color(colorBlueGray))
                            .make(),
                        "Renseigner les champs ci-dessous"
                            .text
                            .color(Color(colorBlueGray))
                            .make()
                      ]),
                )*/
              ],
            ),
            Image.asset(
              "images/others/login_bg.png",
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            "You click, We clean".text.fontFamily('SFPro').size(20).bold.make(),
            Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
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
                        height: 25,
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
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _showPass = !_showPass;
                                  });
                                },
                                child: Icon(
                                  _showPass
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 15,
                                )),
                            suffixIconConstraints: const BoxConstraints(
                                maxHeight: 15, minWidth: 40),
                            labelText: AppLocalizations.current.password),
                        obscureText: !_showPass,
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            //logCustomer();
                          }
                        },
                        controller: _passCtrl,
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
                          if (_formKey.currentState!.validate()) {login()}
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: const Color(colorPrimary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Connexion".text.white.size(18).bold.make()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => UtilsFonction.NavigateAndRemoveRight(
                  context, const RootPage()),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLocalizations.current.passWithoutConnexion.text
                        .color(const Color(colorPrimary))
                        .make(),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            "OU".text.bold.italic.make(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppLocalizations.current.noAccount.text
                    .color(const Color(colorBlueGray))
                    .make(),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => {
                    UtilsFonction.NavigateToRouteAndWait(
                        context,
                        const SignupScreen(
                          toPop: false,
                        )).then((value) {
                      if (_appProvider.login != null) {
                        Navigator.of(context).pop();
                      }
                    })
                  },
                  child: AppLocalizations.current.signUp.text
                      .color(const Color(colorPrimary))
                      .bold
                      .make(),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void login() {
    User user = User(phone: _phoneCtrl.text, password: _passCtrl.text);

    _bloc.logUser(user);
  }
}
