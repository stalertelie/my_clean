import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/services/localization.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TabAppBar(
            titleProp: 'Mes notifications',
            titleFontSize: 20,
            backgroundColor: Colors.transparent,
            context: context,
            centerTitle: true,
            fontWeight: FontWeight.bold,
            showBackButton: false),
        body: /*Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => _notificationItem(),
          itemCount: 30,
        ),
      ),*/
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "images/icons/open_box.svg",
                width: 100,
                color: const Color(colorPrimary),
              ),
              const SizedBox(
                width: 20,
              ),
              AppLocalizations.current.noNotification.text.make()
            ],
          ),
        ));
  }

  Widget _notificationItem() => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(5),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info,
                        color: Color(colorPrimary),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      "Votre commande a bien été réceptionnée"
                          .text
                          .size(10)
                          .bold
                          .make()
                    ],
                  ),
                  "1j".text.gray500.make()
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              "Votre commande pour le service 'Néttoyage à domicile' à bien été réceptionnée. Vous serez contacté sous peu par l'un de nos agent pour la suite. Merci de nous faire confiance"
                  .text
                  .gray500
                  .make()
            ]),
          ),
        ),
      );
}
