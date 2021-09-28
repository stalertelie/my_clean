import 'package:flutter/material.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                Image.asset("images/others/bali_big.png"),
                "Réservation envoyé".text.size(30).bold.make(),
              ],
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Quel étape suivante ?".text.size(18).bold.make(),
                SizedBox(height: 10,),
                "- Nous vous enverrons rapidement un courriel une fois que votre réservation est confirmée".text.make(),
                SizedBox(height: 10,),
                "- Un agent du service clientèle peut prendre contact avec vous pour confirmer les détails de votre demande".text.make(),
                SizedBox(height: 10,),
                "- Vous paierez lorsque le service sera terminé".text.make(),
                SizedBox(height: 10,),
              ],
            ),
          ),
          Expanded(child: InkWell(
            onTap: () => {
              UtilsFonction.NavigateAndRemoveRight(context, RootPage())
            },
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 10,),
                      "RETOUR A L'ACCUEIL".text.color(Color(0XFF01A6DC)).size(18).make(),
                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
