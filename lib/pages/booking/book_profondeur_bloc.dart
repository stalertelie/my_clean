import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/entities/frequence.dart';
import 'package:my_clean/models/entities/prices/prices.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/price.dart';
import 'package:my_clean/models/price_booking.dart';
import 'package:my_clean/models/tarification_object_root.dart';
import 'package:my_clean/pages/booking/booking_bloc.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/request_extension.dart';
import 'package:rxdart/rxdart.dart';

class BookProfondeurBloc extends BaseBloc {
  Stream<DateTime> get bookingDateStream => _bookingDateSubject.stream;
  final _bookingDateSubject = BehaviorSubject<DateTime>();
  BehaviorSubject<DateTime> get bookingDateSubject => _bookingDateSubject;

  Stream<int> get totalStream => _totalSubject.stream;
  final _totalSubject = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<int> get totalSubject => _totalSubject;

  Stream<List<TarificationObjectRoot>> get tarificationRootStream =>
      _tarificationRootSubject.stream;
  final _tarificationRootSubject =
      BehaviorSubject<List<TarificationObjectRoot>>();
  BehaviorSubject<List<TarificationObjectRoot>> get tarificationRootSubject =>
      _tarificationRootSubject;

  Stream<TarificationObjectRoot?> get selectedServiceStream =>
      _selectedServiceSubject.stream;
  final _selectedServiceSubject = BehaviorSubject<TarificationObjectRoot?>();
  BehaviorSubject<TarificationObjectRoot?> get selectedServiceSubject =>
      _selectedServiceSubject;

  Stream<List<DayObject>> get daysStream => _daysSubject.stream;
  final _daysSubject = BehaviorSubject<List<DayObject>>();

  BehaviorSubject<List<DayObject>> get daysSubject => _daysSubject;

  void addTarification(
      TarificationObjectRoot tarificationObjectRoot, int number) {
    List<TarificationObjectRoot> list = _tarificationRootSubject.value;
    int newNumber = list
            .firstWhere((element) => element.id == tarificationObjectRoot.id)
            .total +
        number;
    _selectedServiceSubject.add(_selectedServiceSubject.value);
    list
        .firstWhere((element) => element.id == tarificationObjectRoot.id)
        .total += number;
    _tarificationRootSubject.add(list);
    int total = _selectedServiceSubject.value!.list![0].tarifications!.price! +
        ((newNumber - 1) *
            _selectedServiceSubject
                .value!.list![0].tarifications!.operatorValue!);
    _totalSubject.add(total);
  }

  book(String userID, String localisation, String gps, String note,
      {bool? isMeubler = false}) {
    RequestExtension<Booking> requestExtension = RequestExtension();
    List<Frequence> frequence = [];

    if (_daysSubject.hasValue) {
      for (var element in _daysSubject.value) {
        frequence.add(Frequence(day: element.day, time: element.time));
      }
    }

    List<PriceBooking> listPrice = [];

    listPrice.add(PriceBooking(
      tarification: _selectedServiceSubject.value!.list![0].tarifications!.id,
      quantity: _selectedServiceSubject.value!.total,
    ));

    Booking booking = Booking(
        localisation: localisation,
        gps: gps,
        prices: listPrice,
        date: _bookingDateSubject.hasValue ? _bookingDateSubject.value : null,
        frequence: frequence,
        priceTotal: _totalSubject.value,
        choicesExtra: [],
        note: note,
        user: userID,
        isMeubler: isMeubler);

    loadingSubject.add(Loading(loading: true, message: "Réservation en cours"));
    GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    Future<dynamic> response =
        requestExtension.post(UrlConstant.url_booking, jsonEncode(booking));

    response.then((value) {
      loadingSubject.add(Loading(
        message: MessageConstant.booking_ok,
        hasError: false,
        loading: false,
      ));
    }).catchError((error) {
      print(error);
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.valueOrNull);
    });
  }
}
