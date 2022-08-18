import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/models/entities/booking/booking.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:screenshot/screenshot.dart';

class TicketModelWidget extends StatefulWidget {
  final Booking booking;
  TicketModelWidget({Key? key, required this.booking}) : super(key: key);

  @override
  State<TicketModelWidget> createState() => _TicketModelWidgetState();
}

class _TicketModelWidgetState extends State<TicketModelWidget> {
  ScreenshotController screenshotController = ScreenshotController();

  bool isDownloadButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    String details = "";
    if (widget.booking.prices![0].tarification.service!.categorieService !=
        null) {
      details = (widget.booking.prices![0].quantity).toString() +
          " " +
          (widget.booking.prices![0].tarification.service!.categorieService
                  ?.title ??
              "");
    } else {
      details = (widget.booking.prices![0].quantity).toString() +
          " " +
          (widget.booking.prices![0].tarification.label ?? "");
    }

    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(width: 1.0, color: Colors.green),
                  ),
                  child: const Center(
                    child: Text(
                      'Ticket MyClean',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isDownloadButtonVisible = false;
                    });
                    screenshotController
                        .capture()
                        .then((Uint8List? image) async {
                      if (image != null) {
                        final result = await ImageGallerySaver.saveImage(
                            Uint8List.fromList(image),
                            quality: 60,
                            name: "Titket" + widget.booking.code!);
                        Fluttertoast.showToast(
                            msg: "Ticket enrégistré dans votre galerie",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            textColor: Colors.white,
                            fontSize: 13.0);
                        setState(() {
                          isDownloadButtonVisible = true;
                        });
                      }
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                  child: Visibility(
                    visible: isDownloadButtonVisible,
                    child: Row(
                      children: const [
                        Text(
                          'Télécharger',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.download,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                (widget.booking.prices![0].tarification.service?.title ?? "")
                    .toCapitalized(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Date commande",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(UtilsFonction.formatDate(
                    dateTime: widget.booking.createdAt!,
                    format: 'EEE, dd MMM')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Date et heure prestation",
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text(UtilsFonction.formatDate(
                        dateTime: widget.booking.date!,
                        format: 'EEE, dd MMM à H:mm') +
                    "h"),
              ],
            ),
            DottedBorder(
              color: Colors.black,
              strokeWidth: 1,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("Détail:"), Text(details)]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: BarcodeWidget(
                height: 80,
                barcode: Barcode.code128(),
                data: widget.booking.code!,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Contact :  +225 0102030203',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
