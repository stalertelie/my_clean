import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/booking_tarification.dart';
import 'package:my_clean/models/data_response.dart';
import 'package:my_clean/models/entities/frequence.dart';
import 'package:my_clean/models/extra_service.dart';
import 'package:my_clean/models/frequence_multiplicity.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/price.dart';
import 'package:my_clean/models/price_booking.dart';
import 'package:my_clean/models/responses/get-booking-response/get_booking_response.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/tarification_object.dart';
import 'package:my_clean/models/tarification_object_root.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/booking_api.dart';
import 'package:my_clean/utils/request_extension.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_clean/extensions/extensions.dart';

class BookingBloc extends BaseBloc {
  Stream<List<TarificationObject>> get tarificationsStream =>
      _tarificationsSubject.stream;
  final _tarificationsSubject = BehaviorSubject<List<TarificationObject>>();

  BehaviorSubject<List<TarificationObject>> get tarificationsSubject =>
      _tarificationsSubject;

  Stream<List<TarificationObjectRoot>> get tarificationRootStream =>
      _tarificationRootSubject.stream;
  final _tarificationRootSubject =
      BehaviorSubject<List<TarificationObjectRoot>>();

  BehaviorSubject<List<TarificationObjectRoot>> get tarificationRootSubject =>
      _tarificationRootSubject;

  Stream<DateTime> get bookingDateStream => _bookingDateSubject.stream;
  final _bookingDateSubject = BehaviorSubject<DateTime>();

  BehaviorSubject<DateTime> get bookingDateSubject => _bookingDateSubject;

  Stream<List<DayObject>> get daysStream => _daysSubject.stream;
  final _daysSubject = BehaviorSubject<List<DayObject>>();

  BehaviorSubject<List<DayObject>> get daysSubject => _daysSubject;

  Stream<int> get totalStream => _totalSubject.stream;
  final _totalSubject = BehaviorSubject<int>.seeded(0);

  Stream<int> get totalAbonmentStream => _totalAbonmentSubject.stream;
  final _totalAbonmentSubject = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<int> get totalAbonmentSubject => _totalAbonmentSubject;

  BehaviorSubject<int> get totalSubject => _totalSubject;

  Stream<List<Price>> get simpleTarificationStream =>
      _simpleTarificationSubject.stream;
  final _simpleTarificationSubject = BehaviorSubject<List<Price>>();

  BehaviorSubject<List<Price>> get simpleTarification =>
      _simpleTarificationSubject;

  Stream<List<ExtraService>> get extrasStream => _extrasSubject.stream;
  final _extrasSubject = BehaviorSubject<List<ExtraService>>.seeded([]);

  Stream<List<ExtraService>> get selectedExtrasStream =>
      _selectedExtrasSubject.stream;
  final _selectedExtrasSubject = BehaviorSubject<List<ExtraService>>.seeded([]);
  BehaviorSubject<List<ExtraService>> get selectedExtrasSubject =>
      _selectedExtrasSubject;

  Stream<bool> get isPonctualStream => _isPonctualSubject.stream;
  final _isPonctualSubject = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> get isPonctualSubject => _isPonctualSubject;

  Stream<int> get radioFrequenceStream => _radioFrequenceSubject.stream;
  final _radioFrequenceSubject = BehaviorSubject<int>.seeded(1);
  BehaviorSubject<int> get radioFrequenceSubject => _radioFrequenceSubject;

  Stream<List<String>> get dayListStream => _dayListSubject.stream;
  final _dayListSubject = BehaviorSubject<List<String>>.seeded([]);
  BehaviorSubject<List<String>> get dayListSubject => _dayListSubject;

  Stream<String> get frequenceHoureStream => _frequenceHoureSubject.stream;
  final _frequenceHoureSubject =
      BehaviorSubject<String>.seeded(AppConstant.hourList[0]);
  BehaviorSubject<String> get frequenceHoureSubject => _frequenceHoureSubject;

  Stream<int> get salleBainStream => _salleBainSubject.stream;
  final _salleBainSubject = BehaviorSubject<int>.seeded(0);

  BookingBloc() {
    _tarificationsSubject.add([]);
    _daysSubject.add([]);
  }

  void addDays(String day) {
    if (_dayListSubject.value.contains(day)) {
      _dayListSubject.value.removeWhere((element) => element == day);
    } else {
      if (_radioFrequenceSubject.value > _dayListSubject.value.length) {
        _dayListSubject.value.add(day);
      }
    }
    _dayListSubject.add(_dayListSubject.value);
  }

  getExtratFormServices(String idService) {
    RequestExtension<ExtraService> _requestExtension = RequestExtension();

    Future<dynamic> response =
        _requestExtension.get(UrlConstant.url_extras + "?service=${idService}");
    response.then((value) {
      DataResponse<ExtraService> result = value as DataResponse<ExtraService>;
      if (result.hydraMember != null && result.hydraMember!.isNotEmpty) {
        _extrasSubject.add(result.hydraMember!);
      }
    }).catchError((error) {
      print(error);
    });
  }

  void addExtra(ExtraService extraService) {
    if (!_selectedExtrasSubject.hasValue ||
        _selectedExtrasSubject.value == null) {
      _selectedExtrasSubject.add([]);
    }
    if (_selectedExtrasSubject.value
        .where((element) => element.id == extraService.id)
        .isEmpty) {
      List<ExtraService> list = _selectedExtrasSubject.value;
      list.add(extraService);
      _selectedExtrasSubject.add(list);
      int total = _totalSubject.value;
      total += extraService.price!;
      _totalSubject.add(total);
      totalAbonmentSubject
          .add(totalAbonmentSubject.value + extraService.price!);
    } else {
      _selectedExtrasSubject.value
          .removeWhere((element) => element.id == extraService.id);
      _selectedExtrasSubject.add(_selectedExtrasSubject.value);
      int total = _totalSubject.value;
      total -= extraService.price!;
      _totalSubject.add(total);
      totalAbonmentSubject
          .add(totalAbonmentSubject.value - extraService.price!);
    }
  }

  setTarificationRoot(List<TarificationObjectRoot> list) {
    _tarificationRootSubject.add(list);
  }

  setSimpleTarification(List<Price> tarifications) {
    _simpleTarificationSubject.add(tarifications);
  }

  setDateBooking(DateTime dateTime) {
    _bookingDateSubject.add(dateTime);
  }

  addTarification(Price tarification, int quantity,
      {required int rootId, bool? isOperatorValueNull = false}) {
    print(tarification.price);

    int index = _tarificationRootSubject.value
        .elementAt(rootId)
        .list!
        .indexWhere((element) => element.tarifications!.id == tarification.id);

    if (index != -1) {
      TarificationObject tarificationObject =
          _tarificationRootSubject.value.elementAt(rootId).list![index];
      if (tarificationObject.quantity == 0 && quantity == -1) {
        return;
      }
      tarificationObject.quantity =
          (tarificationObject.quantity ?? 0) + quantity;
      _tarificationRootSubject.add(_tarificationRootSubject.value);
      if (isOperatorValueNull == true) {
        calculateDetailOperatorValueIsNull(quantity);
        return;
      }
      calculateDetail(quantity);
    }
  }

  addTarification3d(Price tarification, int quantity,
      {required int rootId, bool? isOperatorValueNull = false}) {
    print(tarification.price);

    int index = _tarificationRootSubject.value
        .elementAt(rootId)
        .list!
        .indexWhere((element) => element.tarifications!.id == tarification.id);

    if (index != -1) {
      TarificationObject tarificationObject =
          _tarificationRootSubject.value.elementAt(rootId).list![index];
      if (tarificationObject.quantity == 0 && quantity == -1) {
        return;
      }
      if (tarificationObject.quantity == tarification.max && quantity == 1) {
        return;
      }
      tarificationObject.quantity =
          (tarificationObject.quantity ?? 0) + quantity;
      _tarificationRootSubject.add(_tarificationRootSubject.value);
      if (isOperatorValueNull == true) {
        calculateDetailOperatorValueIsNull(quantity);
        return;
      }
      calculateDetail(quantity);
    }
  }

  add3dCustomTarification(int quantity) {
    TarificationObjectRoot tarificationRootObject =
        _tarificationRootSubject.value.elementAt(2);
    TarificationObject tarificationObject = tarificationRootObject.list!
        .where((element) =>
            element.tarifications!.min! <= quantity &&
            element.tarifications!.max! >= quantity)
        .first;
    if (tarificationObject != null) {
      print("Nottt nullll");
      tarificationObject.quantity = quantity;
      _tarificationRootSubject.add(_tarificationRootSubject.value);
      int total = 0;
      total = tarificationObject.tarifications!.price!;
      _totalSubject.add(total);
    }
  }

  addTarificationSimplyAirCondition(Price tarification, int quantity,
      {required int rootId, bool? isOperatorValueNull = false}) {
    int index = _simpleTarificationSubject.value
        .indexWhere((element) => element.id == tarification.id);
    print(index);
    if (tarification.quantity == 0 && quantity == -1) {
      return;
    }
    if (index != -1) {
      Price p = _simpleTarificationSubject.value.elementAt(index);
      p.quantity = (p.quantity ?? 0) + quantity;
      _simpleTarificationSubject.add(_simpleTarificationSubject.value);
      if (isOperatorValueNull == true) {
        calculateDetailOperatorValueIsNull(quantity);
        return;
      }
      calculateDetailSimpleAirConditionner(quantity);
    }
  }

  void calculateDetailOperatorValueIsNull(int number) {
    int total = 0;
    for (var element in _tarificationRootSubject.value) {
      for (var item in element.list!) {
        if (item.quantity! > 0) {
          total += item.tarifications!.price! * item.quantity!;
        }
      }
    }
    _totalSubject.add(total);
  }

  addTarificationSimply(
    Price tarification,
    int quantity,
    int carTypeIndex, {
    required int cleaningTypeIndex,
  }) {
    int total = 0;
    if (carTypeIndex != -1 && cleaningTypeIndex != -1) {
      TarificationObject tarificationActive =
          _tarificationRootSubject.value[carTypeIndex].list![cleaningTypeIndex];
      tarificationActive.quantity = quantity;
      total = (totalSubject.hasValue ? totalSubject.value : 0) +
          tarificationActive.tarifications!.price! *
              tarificationActive.quantity!;
    }
    _totalSubject.add(total);
  }

  addSofaTarification(Price tarification, int quantity, int sofaTypeIndex) {
    int total = 0;
    if (sofaTypeIndex != -1) {
      Price tarificationActive =
          _simpleTarificationSubject.value[sofaTypeIndex];
      if (tarificationActive.quantity == 0 && quantity == -1) {
        return;
      }
      tarificationActive.quantity =
          (tarificationActive.quantity ?? 0) + quantity;
      _simpleTarificationSubject.add(_simpleTarificationSubject.value);

      for (var item in _simpleTarificationSubject.value) {
        if (item.quantity! > 0) {
          total += item.price! * (item.quantity!);
        }
      }
    }

    _totalSubject.add(total);
  }

  addSalleBin(int value) {
    if (value < 1) {
      if (_salleBainSubject.value == 0) {
        return;
      }
    }
    _salleBainSubject.add(_salleBainSubject.value + value);
  }

  addHomeCleanTarification(Price tarification, int quantity, int index) {
    int total = 0;
    int totalAbonnement = 0;
    if (index != -1) {
      Price tarificationActive = _simpleTarificationSubject.value[index];
      if (tarificationActive.quantity == 0 && quantity == -1) {
        return;
      }
      if (tarificationActive.quantity == 5 && quantity != -1) {
        return;
      }
      tarificationActive.quantity =
          (tarificationActive.quantity ?? 0) + quantity;
      _simpleTarificationSubject.add(_simpleTarificationSubject.value);

      for (var item in _simpleTarificationSubject.value) {
        if (item.quantity! > 0) {
          total += item.price! + (item.operatorValue! * (item.quantity! - 1));
          totalAbonnement += item.priceAbonment! +
              (item.operatorValue! * (item.quantity! - 1));
        }
      }
    }

    _totalSubject.add(total);
    _totalAbonmentSubject.add(totalAbonnement);
  }

  addCarpetTarification(Price tarification, int carpetSize, int sofaTypeIndex) {
    int total = 0;
    if (sofaTypeIndex != -1) {
      Price tarificationActive =
          _simpleTarificationSubject.value[sofaTypeIndex];
      tarificationActive.quantity =
          (tarificationActive.quantity ?? 0) + carpetSize;
      _simpleTarificationSubject.add(_simpleTarificationSubject.value);

      total += tarification.price! * carpetSize;
    }

    _totalSubject.add(total);
  }

  void calculateDetail(int number) {
    int total = 0;
    for (var element in _tarificationRootSubject.value) {
      for (var item in element.list!) {
        if (item.quantity! > 0) {
          if (item.tarifications!.priceOperator == null) {
            item.tarifications!.priceOperator! == "+";
          }
          if (item.tarifications!.operatorValue == null) {
            item.tarifications!.operatorValue = item.tarifications!.price;
          }
          if (item.tarifications!.priceOperator! == "+") {
            total += item.tarifications!.price! +
                (item.tarifications!.operatorValue! * (item.quantity! - 1));
          }
        }
      }
    }
    _totalSubject.add(total);
  }

  void calculateDetailSimpleAirConditionner(int number) {
    int total = 0;
    for (var element in _simpleTarificationSubject.value) {
      if (element.quantity! > 0) {
        total += (element.price! * (element.quantity!));
      }
    }
    print("=========TOTAL");
    print(total);
    _totalSubject.add(total);
  }

  addDay(String day, String time) {
    List<DayObject> listDays = _daysSubject.value;
    listDays.add(DayObject(day: day, time: time));
    _daysSubject.add(listDays);
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

    if (_dayListSubject.hasValue) {
      for (var element in _dayListSubject.value) {
        frequence
            .add(Frequence(day: element, time: _frequenceHoureSubject.value));
      }
    }

    List<PriceBooking> listPrice = [];

    if (_tarificationRootSubject.hasValue) {
      for (var element in _tarificationRootSubject.value) {
        element.list?.where((it) => it.quantity! > 0).forEach((el) {
          listPrice.add(PriceBooking(
              quantity: el.quantity, tarification: el.tarifications!.id));
        });
      }
    }

    if (_simpleTarificationSubject.hasValue) {
      for (var element in _simpleTarificationSubject.value) {
        if (element.quantity! > 0) {
          listPrice.add(PriceBooking(
              quantity: element.quantity ?? 1, tarification: element.id));
        }
      }
    }

    Booking booking = Booking(
        localisation: localisation,
        gps: gps,
        date: _bookingDateSubject.hasValue ? _bookingDateSubject.value : null,
        prices: listPrice,
        frequence: frequence.map((e) => "${e.day} à ${e.time} \n").join(","),
        priceTotal: _totalSubject.value,
        choicesExtra: _selectedExtrasSubject.value != null
            ? _selectedExtrasSubject.value.map((e) => e.id!).toList()
            : [],
        note: note,
        user: userID,
        isMeubler: isMeubler);
    if (isPonctualSubject.hasValue && isPonctualSubject.value != true) {
      booking.frequence = "1 fois/semaine, ${booking.frequence}";
    }
    //print(jsonEncode(booking));
    //return;
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

  bookSofa(String userID, String localisation, String gps, String note,
      {bool? isMeubler = false}) {
    RequestExtension<Booking> requestExtension = RequestExtension();
    List<Frequence>? frequence = [];
    for (var element in _daysSubject.value) {
      frequence.add(Frequence(day: element.day, time: element.time));
    }
    List<PriceBooking> listPrice = [];

    for (var element in _simpleTarificationSubject.value) {
      if (element.quantity! > 0) {
        listPrice.add(PriceBooking(
            quantity: element.quantity ?? 1, tarification: element.id));
      }
    }

    Booking booking = Booking(
        localisation: localisation,
        gps: gps,
        date: _bookingDateSubject.hasValue ? _bookingDateSubject.value : null,
        prices: listPrice,
        frequence: frequence.map((e) => "${e.day} à ${e.time} \n").join(","),
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
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    });
  }
}

class DayObject {
  String day;
  String time;

  DayObject({required this.day, required this.time});

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
      };
}
