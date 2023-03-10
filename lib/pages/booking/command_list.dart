// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/components/custom_button.dart';
import 'package:my_clean/components/custom_dialog.dart';
import 'package:my_clean/components/loader.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/models/entities/booking/booking.dart';
import 'package:my_clean/models/responses/get-booking-response/get_booking_response.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/pages/evaluation/booking_evaluate.dart';
import 'package:my_clean/pages/booking/components/command_list_item.dart';
import 'package:my_clean/pages/widgets/ticket_model.dart';
import 'package:my_clean/services/booking_api.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:velocity_x/src/extensions/iterable_ext.dart';
import 'package:velocity_x/velocity_x.dart';

class CommandList extends StatefulWidget {
  final Function(String? serviceId) onServiceRequested;
  const CommandList({Key? key, required this.onServiceRequested})
      : super(key: key);

  @override
  CommandListState createState() => CommandListState();
}

class CommandListState extends State<CommandList> {
  bool loading = true;
  bool loadingMoreLoader = false;

  List<Booking>? commands = [];

  int page = 1;

  final BookingApi bookingApi = Ioc().use('bookingApi');

  int currentFiltreIndex = 0;

  User? globalUser;

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomDialog(contextProp: context, messageProp: message);
      },
    );
  }

  _getUser() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;
    if (user != null) {
      setState(() {
        globalUser = user;
      });
      getUserCommandsList(user.id);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void getUserCommandsList(String? userId) async {
    try {
      GetBookingResponse bookingResponse =
          await bookingApi.getCommandList(id: userId!.substring(7), page: 1);

      if (bookingResponse.hydraMember!.isNotEmpty) {
        setState(() {
          loading = false;
          if (currentFiltreIndex == 0) {
            commands = bookingResponse.hydraMember!
                .where((element) => element.isClosed == false)
                .toList();
          } else {
            commands = bookingResponse.hydraMember!
                .where((element) => element.isClosed == true)
                .toList();
          }
        });
      } else {
        setState(() {
          loading = false;
          commands = [];
        });
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      _showDialog(error.toString());
    }
  }

  Widget _buildCommandList() {
    return commands!.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: Text(AppLocalizations.current.noOrders),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: commands!
                .mapIndexed((command, index) => Container(
                      margin: const EdgeInsets.all(5),
                      //child: CommandListItem(command: command),
                      child: commandItem(command),
                    ))
                .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorDefaultService),
      appBar: TabAppBar(
          titleProp: AppLocalizations.current.myOrders,
          titleFontSize: 20,
          backgroundColor: Colors.transparent,
          context: context,
          centerTitle: true,
          fontWeight: FontWeight.bold,
          showBackButton: false),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(colorGreySecond)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      child: filterContainer(
                          index: 0, title: AppLocalizations.current.active)),
                  Flexible(
                      child: filterContainer(
                          index: 1, title: AppLocalizations.current.history)),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    loading = true;
                  });
                  _getUser();
                },
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          loading
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 2.1 +
                                          37 +
                                          20,
                                  child: Center(
                                      child: Loader(size: 40, strokeWidth: 4)),
                                )
                              : _buildCommandList()
                        ],
                      )),
                )),
          )
        ],
      )),
    );
  }

  Widget filterContainer({required String title, required int index}) =>
      GestureDetector(
        onTap: () {
          setState(() {
            currentFiltreIndex = index;
            if (globalUser != null) {
              getUserCommandsList(globalUser?.id);
            }
          });
        },
        child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index == currentFiltreIndex
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: index == currentFiltreIndex
                  ? BorderRadius.circular(10)
                  : BorderRadius.zero,
            ),
            child: Center(child: title.text.make())),
      );

  Widget commandItem(Booking booking) => Material(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          color: const Color(0XFFE7E7E8),
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLocalizations.current.commandCode.text.make(),
                booking.code!.text.bold.size(15).make(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLocalizations.current.commandeservice.text.make(),
                Flexible(
                  child:
                      "${booking.prices![0].tarification.service?.categorieService != null ? booking.prices![0].tarification.service?.categorieService?.title!.toCapitalized() : '(' + booking.prices![0].quantity.toString() + ')* ' + (booking.prices![0].tarification.label ?? '')} ${booking.prices![0].tarification.service?.title!.toCapitalized()}"
                          .text
                          .make(),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLocalizations.current.commandDate.text.make(),
                Text(
                  AppLocalizations.current.orderDate(UtilsFonction.formatDate(
                      dateTime: booking.date ?? DateTime.now(),
                      format: "d-MM-y")),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                booking.code!.text.bold.size(15).make(),
                Expanded(
                  child:
                      "${booking.prices![0].tarification.service?.categorieService != null ? booking.prices![0].tarification.service?.categorieService?.title : booking.prices![0].quantity.toString() + ' ' + (booking.prices![0].tarification.label ?? '')} ${booking.prices![0].tarification.service?.title!.toCapitalized()}"
                          .text
                          .make(),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              AppLocalizations.current.orderDate(UtilsFonction.formatDate(
                  dateTime: booking.date ?? DateTime.now(), format: "d-MM-y")),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),*/
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                "Total".text.size(18).bold.make(),
                Text(
                  UtilsFonction.formatMoney(booking.priceTotal!.toInt()) +
                      ' Fcfa',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0XFFBFBFBF))),
                      onPressed: () => showTicket(bookingdata: booking),
                      child: Text(
                        AppLocalizations.current.viewRecept,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(colorPrimary))),
                      onPressed: () {
                        widget.onServiceRequested(
                            booking.prices![0].tarification.service!.id);
                      },
                      child: Text(
                        AppLocalizations.current.bookAgain,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Visibility(
                  visible: booking.hasEvaluation != true,
                  child: const SizedBox(
                    width: 5,
                  ),
                ),
                Visibility(
                  visible: booking.hasEvaluation != true,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        UtilsFonction.NavigateToRouteAndWait(context,
                                BookingEvaluateScreen(booking: booking))
                            .then((value) {
                          print('icicici');
                          setState(() {
                            loading = true;
                          });
                          _getUser();
                        });
                      },
                      child: Text(
                        AppLocalizations.current.noteservice,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ]),
        ),
      );

  void showTicket({required Booking bookingdata}) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: TicketWidget(
                width: 350,
                height: 400,
                isCornerRounded: true,
                padding: const EdgeInsets.all(20),
                child: TicketModelWidget(
                  booking: bookingdata,
                ),
              ),
            ));
  }
}
