import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/auth/aut_bloc.dart';
import 'package:my_clean/pages/widgets/widget_template.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _prenomCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  TextEditingController _repassCtrl = TextEditingController();
  TextEditingController _communeCtrl = TextEditingController();

  String? commune;

  bool _showPass = false;

  final _formKey = GlobalKey<FormState>();

  final AuthBloc _bloc = AuthBloc();

  late AppProvider _appProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.loadingSubject.listen((value) {
      if (value.loading == false && value.message == MessageConstant.signupok) {
        _appProvider.updateConnectedUSer(value.data);
        GetIt.I<AppServices>()
            .messengerGlobalKey
            ?.currentState
            ?.clearSnackBars();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(colorPrimary),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(authBlue),
                      ),
                      child: Image.asset("images/icons/logo.png"),
                    ),
                  ),*/
                  SizedBox(
                    height: 20,
                  ),
                  "Créer un compte"
                      .text
                      .size(25)
                      .bold
                      .color(Color(colorBlueGray))
                      .make(),
                  "Renseigner les champs ci-dessous"
                      .text
                      .color(Color(colorBlueGray))
                      .make()
                ],
              ),
            ),
            const SizedBox(
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
                        decoration: WidgetTemplate.getInputStyle("Nom"),
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ réquis";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: WidgetTemplate.getInputStyle("Prénoms"),
                        controller: _prenomCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ réquis";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: WidgetTemplate.getInputStyle("Téléphone"),
                        keyboardType: TextInputType.phone,
                        controller: _phoneCtrl,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ réquis";
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButton<String>(
                          hint: Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: const Text('Commune'),
                          ),
                          isExpanded: true,
                          value: commune,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              commune = newValue;
                            });
                          },
                          items: AppConstant.communeList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SlideInRight(
                          child: TextFormField(
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
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
                        height: 10,
                      ),
                      SlideInRight(
                          child: TextFormField(
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
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
                            labelText: "Ressaisir le mot de passe"),
                        obscureText: !_showPass,
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          if (_formKey.currentState!.validate()) {
                            //logCustomer();
                          }
                        },
                        controller: _repassCtrl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Champ réquis";
                          }
                          if (value != _passCtrl.text) {
                            return "Les mots de passe ne sont pas identiques";
                          } else
                            return null;
                        },
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signupUSer();
                          } else {
                            print("nono");
                          }
                        },
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        color: Color(colorPrimary),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            "Créer un compte".text.white.size(18).bold.make()
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
                  "Avez-vous déjà un compte?"
                      .text
                      .color(Color(colorBlueGray))
                      .make(),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    child: "Se connecter"
                        .text
                        .color(Color(colorPrimary))
                        .bold
                        .make(),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  signupUSer() {
    User user = User(
      commune: commune,
      nom: _nameCtrl.text,
      prenoms: _prenomCtrl.text,
      password: _passCtrl.text,
      phone: _phoneCtrl.text,
    );
    _bloc.createUser(user);
  }
}
