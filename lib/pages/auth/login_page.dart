import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/auth/aut_bloc.dart';
import 'package:my_clean/pages/auth/singup_page.dart';
import 'package:my_clean/pages/home/home_header.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();

  late AppProvider _appProvider;

  bool _showPass = false;

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
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
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
                          "images/icons/logo.png",
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                  clipper: BottomWaveClipper(distance: 150),
                ),
                SizedBox(
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
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: WidgetTemplate.getInputStyle("Téléphone"),
                        keyboardType: TextInputType.phone,
                        controller: _phoneCtrl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ réquis";
                          }
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SlideInRight(
                          child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(2),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1)),
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
                            suffixIconConstraints:
                                BoxConstraints(maxHeight: 15, minWidth: 40),
                            labelText: "Mot de passe"),
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
                            return "Champ réquis";
                          } else
                            return null;
                        },
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () => {
                          if (_formKey.currentState!.validate()) {login()}
                        },
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        color: Color(colorPrimary),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  "N'avez-vous pas de compte ?"
                      .text
                      .color(Color(colorBlueGray))
                      .make(),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => {
                      UtilsFonction.NavigateToRouteAndWait(
                              context, SignupScreen())
                          .then((value) {
                        print(GetIt.I<AppServices>().userData);
                        print("icicicic");
                        if (_appProvider.login != null) {
                          Navigator.of(context).pop();
                        }
                      })
                    },
                    child: "S'inscrire"
                        .text
                        .color(Color(colorPrimary))
                        .bold
                        .make(),
                  )
                ],
              ),
            ),
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
