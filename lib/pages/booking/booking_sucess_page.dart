import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingResultScreen extends StatefulWidget {
  @override
  State<BookingResultScreen> createState() => _BookingResultScreenState();
}

class _BookingResultScreenState extends State<BookingResultScreen> {
  double evaluationValue = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(colorDefaultService),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Icon(
                    Icons.done_outline_sharp,
                    color: Colors.green,
                    size: 100,
                  ),
                  AppLocalizations.current.bookingDone
                      .toUpperCase()
                      .text
                      .size(20)
                      .bold
                      .make(),
                  const SizedBox(
                    height: 20,
                  ),
                  AppLocalizations.current.bookingDoneMessage.text
                      .size(15)
                      .make(),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () =>
                  {UtilsFonction.NavigateAndRemoveRight(context, RootPage())},
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Color(colorPrimary),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppLocalizations.current.finish.text.bold.white
                            .size(25)
                            .make(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
