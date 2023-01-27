import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/models/evaluation.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/pages/evaluation/evaluate_bloc.dart';
import 'package:my_clean/pages/root/root_page.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:my_clean/models/entities/booking/booking.dart';

import '../../models/entities/services/services.dart';

class BookingEvaluateScreen extends StatefulWidget {
  final Booking booking;

  const BookingEvaluateScreen({Key? key, required this.booking})
      : super(key: key);

  @override
  State<BookingEvaluateScreen> createState() => _BookingEvaluateScreenState();
}

class _BookingEvaluateScreenState extends State<BookingEvaluateScreen> {
  double evaluationValue = 0;

  final EvaluateBloc _bloc = EvaluateBloc();

  String _currentLocaleCode = '';

  @override
  void initState() {
    super.initState();
    _getLocale();
    _bloc.loadingSubject.listen((value) {
      if (value.message == MessageConstant.evaluation_ok) {
        Navigator.of(context).pop();
        GetIt.I<AppServices>().showSnackbarWithState(Loading(
            loading: false,
            hasError: false,
            message: _currentLocaleCode.toLowerCase() == 'en'
                ? "Rating send"
                : "Evaluation envoyée"));
      }
    });
  }

  void _getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLocaleCode = prefs.getString('locale');

    setState(() {
      _currentLocaleCode = currentLocaleCode!.toLowerCase();
    });
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "images/others/evaluationicon.png",
                    height: 150,
                  ),
                  AppLocalizations.current.serviceEvaluate.text
                      .size(25)
                      .bold
                      .make(),
                  const SizedBox(
                    height: 30,
                  ),
                  RatingStars(
                    value: evaluationValue,
                    onValueChanged: (value) {
                      setState(() {
                        evaluationValue = value;
                      });
                    },
                    starBuilder: (index, color) => Icon(
                      Icons.star,
                      color: color,
                      size: 50,
                    ),
                    starCount: 5,
                    starSize: 40,
                    maxValue: 5,
                    starSpacing: 5,
                    maxValueVisibility: true,
                    valueLabelVisibility: false,
                    animationDuration: const Duration(milliseconds: 1000),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: const Color.fromARGB(255, 219, 200, 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  evaluationValue.text.bold.italic.make()
                  /*Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLocalizations.current.orderDetails.text
                            .color(const Color(colorPrimary))
                            .make(),
                        const Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                  )*/
                ],
              ),
            ),

            /*Padding(
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
            ),*/
            Expanded(
              child: Container(),
            ),
            InkWell(
              onTap: () => {
                if (evaluationValue > 0) {evaluate()}
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(colorPrimary),
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

  void evaluate() {
    Evaluation evaluation = Evaluation(
        bookingId: widget.booking.id,
        note: evaluationValue.toDouble(),
        service: widget.booking.prices![0].tarification.service!.id);

    _bloc.evaluate(evaluation);
  }
}
