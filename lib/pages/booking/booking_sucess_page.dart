import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingResultScreen extends StatefulWidget {
  const BookingResultScreen({Key? key}) : super(key: key);

  @override
  State<BookingResultScreen> createState() => _BookingResultScreenState();
}

class _BookingResultScreenState extends State<BookingResultScreen> {
  double evaluationValue = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TabAppBar(
            titleProp: "",
            context: context,
            backgroundColor: const Color(colorDefaultService)),
        backgroundColor: const Color(colorDefaultService),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: Cro,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Icon(
                    Icons.done_outline_sharp,
                    color: Colors.green,
                    size: 100,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  AppLocalizations.current.bookingDone.text
                      .size(20)
                      .bold
                      .make(),
                  const SizedBox(
                    height: 20,
                  ),
                  // AppLocalizations.current.bookingDoneMessage.text
                  //     .size(15)
                  //     .make(),
                ],
              ),
            ),
            InkWell(
              onTap: () => {
                UtilsFonction.NavigateAndRemoveRight(context, const RootPage())
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: const Color(colorPrimary),
                        borderRadius: BorderRadius.circular(10.0)),
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
