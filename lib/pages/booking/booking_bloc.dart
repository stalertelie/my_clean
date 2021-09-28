import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/booking_tarification.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/tarification.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/request_extension.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_clean/extensions/extensions.dart';

class BookingBloc extends BaseBloc {
  Stream<List<TarificationObject>> get tarificationsStream =>
      _tarificationsSubject.stream;
  final _tarificationsSubject = BehaviorSubject<List<TarificationObject>>();

  BehaviorSubject<List<TarificationObject>> get tarificationsSubject =>
      _tarificationsSubject;


  BookingBloc() {
    _tarificationsSubject.add([]);
  }


  addTarification(Tarification tarification, int quantity) {
    int index = _tarificationsSubject.value.indexWhere((element) =>
    element.tarifications!.id == tarification.id);
    if (index != -1) {
      TarificationObject tarificationObject = _tarificationsSubject
          .value[index];
      if (tarificationObject.quantity == 0 && quantity == -1) {
        return;
      }
      tarificationObject.quantity =
          (tarificationObject.quantity ?? 0) + quantity;

      _tarificationsSubject.add(_tarificationsSubject.value);
    } else {
      List<TarificationObject> list = _tarificationsSubject.value;
      if (list.isNotEmpty && list != null) {
        list.add(TarificationObject(
            tarifications: tarification, quantity: quantity));
      } else {
        if (quantity < 0) {
          return;
        }
        list =
        [TarificationObject(tarifications: tarification, quantity: quantity)];
      }
      _tarificationsSubject.add(list);
    }
  }

  book(String userID, String? frequence, String localisation) {
    RequestExtension<Booking> requestExtension = RequestExtension();

    Booking booking = Booking(
       localisation: localisation,
        bookingTarifications: _tarificationsSubject.value.where((
            element) => element.quantity != null && element.quantity! > 0)
            .map((e) => BookingTarification(
            quantity: e.quantity!, tarification: e.tarifications!.id))
            .toList(),frequence: [frequence!],user: userID);

    loadingSubject.add(Loading(loading: true, message: "Réservation en cours"));
    GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    Future<dynamic> response = requestExtension.post(UrlConstant.url_booking,jsonEncode(booking));

    response.then((value) {
      loadingSubject.add(Loading(message: MessageConstant.booking_ok,
          hasError: false,
          loading: false,
      ));
    }).catchError((error) {
      print(error);
      loadingSubject.add(Loading(message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    });
  }
}
