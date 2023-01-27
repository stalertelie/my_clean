import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clean/components/tab_app_bar.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/models/entities/booking/booking.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/src/extensions/iterable_ext.dart';

class CommandDetails extends StatefulWidget {
  const CommandDetails(
      {Key? key,
      required this.command,
      required this.getImage,
      required this.getTitle})
      : super(key: key);
  final Booking command;
  final Function getImage;
  final Function getTitle;

  @override
  CommandDetailsState createState() => CommandDetailsState();
}

class CommandDetailsState extends State<CommandDetails> {
  User? userInfos;

  @override
  void initState() {
    _getUserInfos();
    super.initState();
  }

  String getImageUrl() {
    return 'http://myclean.novate-media.com/service/' + widget.getImage();
  }

  _getUserInfos() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;

    setState(() {
      userInfos = user;
    });
  }

  Column _buildFrequenceItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [] /*widget.command.frequence!
          .mapIndexed((e, i) => Text('${e.day} à ${e.time}'))
          .toList()*/
      ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorGreyShadeLight,
      appBar: TabAppBar(
          titleProp: AppLocalizations.current.orderDetails,
          titleFontSize: 18,
          context: context,
          centerTitle: true,
          showBackButton: true),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.current.orderNo +
                                  ': ${widget.command.id}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(AppLocalizations.current.bookingDate +
                                " : ${UtilsFonction.formatDate(dateTime: widget.command.date ?? DateTime.now(), format: "d-MM-y à h:mm")}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Total : ${UtilsFonction.formatMoney(widget.command.priceTotal!.toInt()) + ' FCFA'}')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.current.bookingItems.toUpperCase(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.getImage() != ''
                                ? Image.network(getImageUrl(),
                                    height: 70, width: 70, fit: BoxFit.fill)
                                : Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.blue.shade50,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Image non \n disponible',
                                      style: TextStyle(fontSize: 10),
                                    )),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.getTitle().length > 30
                                      ? widget.getTitle().substring(0, 30) +
                                          '...'
                                      : widget.getTitle(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text("Note utilisateur :"),
                                const SizedBox(
                                  height: 5,
                                ),
                                widget.command.note != null &&
                                        widget.command.note != ''
                                    ? Text(
                                        widget.command.note.toString(),
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      )
                                    : const Text('Pas de notes',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic))
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star,
                              color: colorOrange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Paiement'.toUpperCase(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.current.paymentMod,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: const <Widget>[
                                Text("Payer cash l'exécution du service"),
                                SizedBox(
                                  width: 5,
                                ),
                                Spacer(),
                                Icon(
                                  Icons.attach_money,
                                  color: colorOrange,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Service récurrent'.toUpperCase(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'Dates des prestations',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            widget.command.frequence!.isNotEmpty
                                ? _buildFrequenceItem()
                                : const Text(
                                    'Pas de services récurrent pour cette commande',
                                    style: TextStyle(fontSize: 12),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.current.billing.toUpperCase(),
                      style: const TextStyle(fontSize: 14.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${userInfos?.prenoms} ${userInfos?.nom}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("+225${userInfos!.phone}"),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("${widget.command.localisation}")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
