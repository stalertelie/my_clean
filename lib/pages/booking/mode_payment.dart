import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/services/localization.dart';
import 'package:velocity_x/velocity_x.dart';

class ModePaymentScreen extends StatefulWidget {
  const ModePaymentScreen({Key? key}) : super(key: key);

  @override
  State<ModePaymentScreen> createState() => _ModePaymentScreenState();
}

class _ModePaymentScreenState extends State<ModePaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorDefaultService),
      appBar: AppBar(
        title: Text(
          AppLocalizations.current.paymentMethod,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: const Color(colorDefaultService),
        elevation: 0,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(child: SvgPicture.asset('images/others/credit_card.svg')),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: PaimentOptionWidget(
                  title: 'Payer cash après la livraison',
                  bgColor: const Color(colorPrimary),
                  titleColor: Colors.white,
                  logo: Image.asset(
                    'images/icons/cash.png',
                    height: 30,
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: "Ou".text.bold.size(30).make(),
            ),
            const SizedBox(
              height: 20,
            ),
            PaimentOptionWidget(
                title: 'Choisir un paiement mobile',
                bgColor: Colors.grey.shade400,
                logo: SvgPicture.asset('images/icons/mobile_money.svg')),
            const SizedBox(
              height: 20,
            ),
            PaimentOptionWidget(
                title: 'Ajouter une carte',
                bgColor: Colors.grey.shade400,
                logo: Image.asset(
                  'images/icons/card_type.png',
                  width: 120,
                ))
          ],
        ),
      )),
    );
  }

  Widget PaimentOptionWidget(
          {required String title,
          required Widget logo,
          Color bgColor = Colors.white,
          Color titleColor = Colors.black}) =>
      Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: bgColor),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [title.text.color(titleColor).make(), logo]),
        ),
      );
}
