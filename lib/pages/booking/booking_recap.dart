import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/pages/booking/mode_payment.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class BookingRecapScreen extends StatefulWidget {
  final Services services;
  final Frequence? frequence;
  final String? lieu;
  final int amount;
  final int frequenceByWeek;
  final List<String> days;
  final String hour;
  final DateTime bookingDate;
  final bool isSubscription;
  final Function({String note}) onValidate;

  const BookingRecapScreen(
      {Key? key,
      required this.services,
      required this.frequence,
      this.lieu,
      required this.amount,
      required this.onValidate,
      this.frequenceByWeek = 0,
      this.days = const [],
      this.hour = "",
      this.isSubscription = false,
      required this.bookingDate})
      : super(key: key);

  @override
  State<BookingRecapScreen> createState() => _BookingRecapScreenState();
}

class _BookingRecapScreenState extends State<BookingRecapScreen> {
  bool showNoteView = false;

  TextEditingController noteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? lieu = widget.lieu;
    if (lieu != null && lieu.length > 30) {
      lieu = lieu.substring(0, 30);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(colorDefaultService),
        appBar: AppBar(
          backgroundColor: const Color(colorDefaultService),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'images/others/recap_top_bg.png',
                  width: 200,
                ),
              ),
              Center(
                child: "Récapitulatif"
                    .text
                    .bold
                    .size(30)
                    .color(const Color(colorPrimary))
                    .make(),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child:
                    "(Prix : ${UtilsFonction.formatMoney(widget.amount)} Fcfa)"
                        .text
                        .bold
                        .size(25)
                        .make(),
              ),
              const SizedBox(
                height: 20,
              ),
              'Service : '.text.make(),
              const SizedBox(
                height: 10,
              ),
              "${widget.services.title}".text.size(18).bold.make(),
              Visibility(
                visible: widget.isSubscription == true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    "Passage récurrent".text.make(),
                    "${widget.frequenceByWeek} fois par semaine".text.make(),
                    widget.days.join(",").text.size(18).bold.make(),
                    "à, ${widget.hour}".text.size(18).bold.make(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: !widget.isSubscription,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLocalizations.current.bookingDate.text.make(),
                    UtilsFonction.formatDate(
                            dateTime: widget.bookingDate,
                            format: 'EEE d MMMM, H:m')
                        .text
                        .size(18)
                        .bold
                        .make(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showNoteView = !showNoteView;
                  });
                },
                child: Row(
                  children: [
                    AppLocalizations.current.bookingInstruction.text.make(),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: showNoteView
                          ? Icon(Icons.cancel, size: 13, color: Colors.red)
                          : SvgPicture.asset(
                              "images/icons/edit.svg",
                              width: 15,
                            ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                  visible: showNoteView,
                  child: TextField(
                    maxLines: 10,
                    minLines: 5,
                    maxLength: 160,
                    controller: noteCtrl,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.current.enterYourNote,
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: const TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  )),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () =>
                    UtilsFonction.NavigateToRoute(context, ModePaymentScreen()),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppLocalizations.current.addPaymentMethod.text
                            .color(const Color(colorPrimary))
                            .make(),
                        const Icon(Icons.keyboard_arrow_right)
                      ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AppLocalizations.current.deliveryPayment.text.bold.make(),
              const SizedBox(
                height: 10,
              ),
              AppLocalizations.current.deliveryPlace.text.make(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (lieu ?? '').text.bold.size(18).make(),
                  IconButton(
                    icon: SvgPicture.asset(
                      "images/icons/edit.svg",
                      width: 15,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
        bottomNavigationBar: Material(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              height: 100,
              child: CustomButton(
                  contextProp: context,
                  textProp: AppLocalizations.current.order,
                  borderRadius: BorderRadius.circular(10),
                  onPressedProp: () => widget.onValidate(note: noteCtrl.text)),
            ),
          ),
        ),
      ),
    );
  }
}
