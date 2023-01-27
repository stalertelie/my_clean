import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/services/localization.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class UtilsFonction extends Object {
  static Future<bool> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static bool validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(email);
  }

  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static void showModal(BuildContext context, Widget widget) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(
          milliseconds:
              300), // How long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // Makes widget fullscreen
        return SizedBox(
          height: MediaQuery.of(context).size.height - 150,
          width: MediaQuery.of(context).size.width - 100,
          child: widget,
        );
      },
    );
  }

  static String formatDate({String? format, required DateTime dateTime}) {
    final DateFormat formatter =
        DateFormat(format ?? 'dd/MM/yyyy', AppLocalizations.current.localeName);
    return formatter.format(dateTime);
  }

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
      height: 70,
      width: 70,
    );
  }

  /*static Future<Uint8List> compressImage(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 500,
      minWidth: 1000,
      quality: 50,
    );
    print(list.length);
    print(result.length);
    return result;
  }*/

  static String reformatMessageFromServeur(String msg) {
    String messageError = msg;

    if (msg != null) {
      messageError = msg.trim() == "Operation effectuee avec succes:"
          ? messageError.replaceAll("Operation effectuee avec succes:",
              "Operation effectuée avec succès.")
          : messageError.replaceAll("Operation effectuee avec succes:", "");
      messageError = messageError.replaceAll("Operation effectuee avec succes:",
          "Operation effectuée avec succès");
      messageError = messageError.replaceAll(
          "Impossible de se connecter a la base de donnees:", "");
      messageError =
          messageError.replaceAll("La base de donnees est indisponible:", "");
      messageError = messageError.replaceAll(
          "Permission refusee par la base de donnees:", "");
      messageError = messageError.replaceAll(
          "Le serveur de base de donnees a refuse la requete:", "");
      messageError = messageError.replaceAll("Authentification echouee:", "");
      messageError = messageError.replaceAll("Donnee existante:", "");
      messageError = messageError.replaceAll(
          "Liste vide : il n'y a pas de donnees respectant ce critere:", "");
      messageError = messageError.replaceAll(
          "il n'y a pas de donnees respectant ce critere", "");
      messageError = messageError.replaceAll("Champ non renseigne:", "");
      messageError = messageError.replaceAll("Utilisateur deja connecte:", "");
      messageError = messageError.replaceAll(
          "la requete attendue n'est pas celle fournie:", "");
      messageError = messageError.replaceAll("Le type est incorrect:", "");
      messageError =
          messageError.replaceAll("Le format de la date est incorrect:", "");
      messageError = messageError.replaceAll(
          "le serveur a signale un format invalide:", "");
      messageError =
          messageError.replaceAll("le code de la langue n'est pas valide:", "");
      messageError =
          messageError.replaceAll("La periode de date n'est pas valide", "");
      messageError = messageError.replaceAll(
          "une erreur est survenue lors de l'enregistrement:", "");
      messageError =
          messageError.replaceAll("le name de l'entite n'est pas valide:", "");
      messageError = messageError.replaceAll(
          "Veuillez renseigner une seule valeur pour cette donnee:", "");
      messageError = messageError.replaceAll(
          "La somme des pourcentages ne doit exceder 100:", "");
      messageError =
          messageError.replaceAll("Erreur de generation de fichier:", "");
      messageError =
          messageError.replaceAll("Operation interdite/refusee:", "");
      messageError = messageError.replaceAll(
          "Ccette donnees ne peut etre supprimee car elle est utilisee:", "");
      messageError =
          messageError.replaceAll("cette donnees est trop superieure:", "");
      messageError = messageError.replaceAll(
          "Vous n'etes pas autoriser a effectuer cette operation.", "");
      messageError = messageError.replaceAll("Donnee inexistante:", "");
      messageError = messageError.replaceAll("Erreur interne:", "");
      messageError = messageError.replaceAll(
          "Le serveur de base de donnees a refuse la requete:", "");
      messageError = messageError.replaceAll(
          "cette donnees ne peut etre supprimee car elle est utilisee:", "");
      messageError = messageError.replaceAll(
          "Vous n'etes pas autoriser a effectuer cette operation.", "");
    }
    return messageError;
  }

  static String formatMoney(int money) {
    var formatter = NumberFormat('#,##0');
    return formatter.format(money).replaceAll(',', '.');
  }

  static void NavigateAndRemoveRight(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            alignment: Alignment.bottomCenter,
            child: page),
        (Route<dynamic> route) => false);
  }

  static void NavigateToRoute(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
        return page;
      }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }),
    );
  }

  static Future<dynamic> NavigateToRouteAndWait(
          BuildContext context, Widget page) =>
      Navigator.of(context).push(
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }),
      );

  static Image ImageFromNetwork(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
    );
  }

  static CachedNetworkImage CachedImage(String url,
      {BlendMode blendmod = BlendMode.color,
      Color c = Colors.transparent,
      double? width}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => ConstrainedBox(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
          constraints: const BoxConstraints(maxHeight: 40, maxWidth: 40)),
      fit: BoxFit.fill,
      width: width ?? double.maxFinite,
      colorBlendMode: blendmod,
      color: c,
    );
  }

  static Future<bool?> showExitDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Voulez-vous vraiment vous déconnecter ?"),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ZoomIn(
                  child: TextButton(
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                ZoomIn(
                  child: TextButton(
                    child: const Text(
                      "Oui",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ));
  }

  static Future<bool?> showConfirmDialog(BuildContext context, String msg) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(msg),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ZoomIn(
                  child: TextButton(
                    child: const Text(
                      "Annuler",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                ZoomIn(
                  child: TextButton(
                    child: const Text(
                      "Oui",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ));
  }

  static String removeExceptionString(String msg) {
    return msg.replaceFirst("Exception", "");
  }

  static Future<bool?> showErrorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(message),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              actions: <Widget>[
                ZoomIn(
                  child: TextButton(
                    child: const Text(
                      "FERMER",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
              ],
            ));
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static void showLoading(BuildContext ctx, String message) {
    showDialog(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              backgroundColor: const Color(colorPrimary).withOpacity(0.6),
              content: SizedBox(
                height: 100,
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    message.text.color(Colors.white).make(),
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(
                      backgroundColor: Color(colorPrimary),
                    )
                  ],
                ),
              ),
            ));
  }

  static void showSnackbar(
      Loading loading, GlobalKey<ScaffoldState> key, BuildContext context) {
    if (key.currentState != null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (loading.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: loading.loading == true
              ? const Duration(minutes: 1)
              : const Duration(seconds: 5),
          content: loading.loading == true
              ? Row(
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const SizedBox(
                      width: 50,
                    ),
                    Flexible(child: Text(loading.message ?? ""))
                  ],
                )
              : !(loading.hasError ?? false)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                            child: (loading.message ?? "")
                                .text
                                .green400
                                .semiBold
                                .make())
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                            child: (loading.message ?? "").text.red400.make()),
                      ],
                    ),
        ));
      }
    }
  }

  static void showSnackbarWithState(
      Loading loading, ScaffoldState state, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    if (loading.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: loading.loading == true
            ? const Duration(minutes: 1)
            : const Duration(seconds: 5),
        content: loading.loading == true
            ? Row(
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(
                    width: 50,
                  ),
                  Flexible(child: Text(loading.message ?? ""))
                ],
              )
            : !(loading.hasError ?? true)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: (loading.message ?? "")
                              .text
                              .green400
                              .semiBold
                              .make())
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: (loading.message ?? "").text.red400.make()),
                    ],
                  ),
      ));
    }
  }
}
