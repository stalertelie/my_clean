import 'package:flutter/material.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/constants/colors_constant.dart';
import 'package:my_clean/constants/img_urls.dart';
import 'package:my_clean/models/entities/booking/booking.dart';
import 'package:my_clean/pages/booking/command_details.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/utils/utils_fonction.dart';

class CommandListItem extends StatelessWidget {
  final Booking command;

  const CommandListItem({Key? key, required this.command}) : super(key: key);

  String getBookingTitle() {
    if (command.prices!.isNotEmpty) {
      if (command.prices![0].tarification.service!.categorieService == null) {
        return command.prices![0].tarification.service!.title!.toLowerCase();
      }
      return command.prices![0].tarification.service!.categorieService!.title!
          .toLowerCase();
    }
    return '';
  }

  String getImage() {
    if (command.prices!.isNotEmpty) {
      if (command.prices![0].tarification.service!.categorieService == null) {
        return command.prices![0].tarification.service!.image.toString();
      }
      return command.prices![0].tarification.service!.categorieService!.image
          .toString();
    }
    return '';
  }

  String getImageUrl() {
    return 'http://myclean.novate-media.com/service/' + getImage();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommandDetails(
              command: command,
              getImage: getImage,
              getTitle: getBookingTitle,
            ),
          ),
        );
      },
      key: const Key('command-list-item'),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getImage() != ''
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      getBookingTitle().length > 30
                          ? getBookingTitle().substring(0, 30) + '...'
                          : getBookingTitle(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(AppLocalizations.current.orderDate(
                        UtilsFonction.formatDate(
                            dateTime: command.date ?? DateTime.now(),
                            format: "d-MM-y"))),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        UtilsFonction.formatMoney(command.priceTotal!.toInt()) +
                            ' FCFA')
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
      ),
    );
  }
}
