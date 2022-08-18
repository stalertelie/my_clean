import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/messages_all.dart';

class AppLocalizations {
  AppLocalizations(Locale locale) : localeName = locale.toString() {
    current = this;
  }

  static late AppLocalizations current;

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        (locale.countryCode == null || locale.countryCode!.isEmpty)
            ? locale.languageCode
            : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return AppLocalizations(locale);
    });
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  final String localeName;

  String get myOrders {
    return Intl.message('myOrders', name: 'myOrders', locale: localeName);
  }

  String get myBooking {
    return Intl.message('myBooking', name: 'myBooking', locale: localeName);
  }

  String get notifications {
    return Intl.message('notifications',
        name: 'notifications', locale: localeName);
  }

  String get noOrders {
    return Intl.message('noOrders', name: 'noOrders', locale: localeName);
  }

  String get whatService {
    return Intl.message('whatService', name: 'whatService', locale: localeName);
  }

  String orderDate(date) {
    return Intl.message('orderDate',
        name: 'orderDate', locale: localeName, args: [date]);
  }

  String get chooseYourCountry {
    return Intl.message('chooseYourCountry',
        name: 'chooseYourCountry', locale: localeName);
  }

  String get chooseYourLanguage {
    return Intl.message('chooseYourLanguage',
        name: 'chooseYourLanguage', locale: localeName);
  }

  String get goOn {
    return Intl.message('continue', name: 'continue', locale: localeName);
  }

  String get profileDetailsLabel {
    return Intl.message('profileDetailsLabel',
        name: 'profileDetailsLabel', locale: localeName);
  }

  String get logout {
    return Intl.message('logout', name: 'logout', locale: localeName);
  }

  String get myAccount {
    return Intl.message('myAccount', name: 'myAccount', locale: localeName);
  }

  String get myInvoice {
    return Intl.message('myInvoice', name: 'myInvoice', locale: localeName);
  }

  String get helpCenter {
    return Intl.message('helpCenter', name: 'helpCenter', locale: localeName);
  }

  String get promoCode {
    return Intl.message('promoCode', name: 'promoCode', locale: localeName);
  }

  String get changeLanguage {
    return Intl.message('changeLanguage',
        name: 'changeLanguage', locale: localeName);
  }

  String get comingSoon {
    return Intl.message('comingSoon', name: 'comingSoon', locale: localeName);
  }

  String get changePassword {
    return Intl.message('changePassword',
        name: 'changePassword', locale: localeName);
  }

  String get shareApp {
    return Intl.message('shareApp', name: 'shareApp', locale: localeName);
  }

  String appDownloadLink(downloadLink) {
    return Intl.message('appDownloadLink',
        name: 'appDownloadLink', locale: localeName, args: [downloadLink]);
  }

  String get account {
    return Intl.message('account', name: 'account', locale: localeName);
  }

  String get home {
    return Intl.message('home', name: 'home', locale: localeName);
  }

  String get youAreNotLogged {
    return Intl.message('youAreNotLogged',
        name: 'youAreNotLogged', locale: localeName);
  }

  String get disconnected {
    return Intl.message('disconnected',
        name: 'disconnected', locale: localeName);
  }

  String get conditionsOfUse {
    return Intl.message('conditionsOfUse',
        name: 'conditionsOfUse', locale: localeName);
  }

  String get firstNameFieldLabel {
    return Intl.message('firstNameFieldLabel',
        name: 'firstNameFieldLabel', locale: localeName);
  }

  String get lastNameFieldLabel {
    return Intl.message('lastNameFieldLabel',
        name: 'lastNameFieldLabel', locale: localeName);
  }

  String get phone {
    return Intl.message('phone', name: 'phone', locale: localeName);
  }

  String get commune {
    return Intl.message('commune', name: 'commune', locale: localeName);
  }

  String get somethingIsWrongErrorLabel {
    return Intl.message('somethingIsWrongErrorLabel',
        name: 'somethingIsWrongErrorLabel', locale: localeName);
  }

  String get welcome {
    return Intl.message('welcome', name: 'welcome', locale: localeName);
  }

  String get chooseService {
    return Intl.message('chooseService',
        name: 'chooseService', locale: localeName);
  }

  String get order {
    return Intl.message('order', name: 'order', locale: localeName);
  }

  String get furnishedHouse {
    return Intl.message('furnishedHouse',
        name: 'furnishedHouse', locale: localeName);
  }

  String get isYourHouseFurnished {
    return Intl.message('isYourHouseFurnished',
        name: 'isYourHouseFurnished', locale: localeName);
  }

  String get yes {
    return Intl.message('yes', name: 'yes', locale: localeName);
  }

  String get no {
    return Intl.message('no', name: 'no', locale: localeName);
  }

  String get isThereAnythingElse {
    return Intl.message('isThereAnythingElse',
        name: 'isThereAnythingElse', locale: localeName);
  }

  String get enterYourNote {
    return Intl.message('enterYourNote',
        name: 'enterYourNote', locale: localeName);
  }

  String get dateAndHour {
    return Intl.message('dateAndHour', name: 'dateAndHour', locale: localeName);
  }

  String get whenDoYouWantTheExecution {
    return Intl.message('whenDoYouWantTheExecution',
        name: 'whenDoYouWantTheExecution', locale: localeName);
  }

  String get selectDate {
    return Intl.message('selectDate', name: 'selectDate', locale: localeName);
  }

  String get selectHour {
    return Intl.message('selectHour', name: 'selectHour', locale: localeName);
  }

  String get addDate {
    return Intl.message('addDate', name: 'addDate', locale: localeName);
  }

  String get each {
    return Intl.message('each', name: 'each', locale: localeName);
  }

  String get at {
    return Intl.message('at', name: 'at', locale: localeName);
  }

  String get pleaseChooseAtLeastOneOption {
    return Intl.message('pleaseChooseAtLeastOneOption',
        name: 'pleaseChooseAtLeastOneOption', locale: localeName);
  }

  String get book {
    return Intl.message('book', name: 'book', locale: localeName);
  }

  String get orderSummary {
    return Intl.message('orderSummary',
        name: 'orderSummary', locale: localeName);
  }

  String get duration {
    return Intl.message('duration', name: 'duration', locale: localeName);
  }

  String get address {
    return Intl.message('address', name: 'address', locale: localeName);
  }

  String get totalAmountToPay {
    return Intl.message('totalAmountToPay',
        name: 'totalAmountToPay', locale: localeName);
  }

  String get validate {
    return Intl.message('validate', name: 'validate', locale: localeName);
  }

  String get enterAnAdress {
    return Intl.message('enterAnAdress',
        name: 'enterAnAdress', locale: localeName);
  }

  String get orderDetails {
    return Intl.message('orderDetails',
        name: 'orderDetails', locale: localeName);
  }

  String get passWithoutConnexion {
    return Intl.message('passWithoutConnexion',
        name: 'passWithoutConnexion', locale: localeName);
  }

  String get noAccount {
    return Intl.message('noAccount', name: 'noAccount', locale: localeName);
  }

  String get signUp {
    return Intl.message('signUp', name: 'signUp', locale: localeName);
  }

  String get numTel {
    return Intl.message('numTel', name: 'numTel', locale: localeName);
  }

  String get password {
    return Intl.message('password', name: 'password', locale: localeName);
  }

  String get selectMatiere {
    return Intl.message('selectMatiere',
        name: 'selectMatiere', locale: localeName);
  }

  String get numberPlace {
    return Intl.message('numberPlace', name: 'numberPlace', locale: localeName);
  }

  String get steamCleaning {
    return Intl.message('steamCleaning',
        name: 'steamCleaning', locale: localeName);
  }

  String get chooseTypeHouse {
    return Intl.message('chooseTypeHouse',
        name: 'chooseTypeHouse', locale: localeName);
  }

  String get numberRoom {
    return Intl.message('numberRoom', name: 'numberRoom', locale: localeName);
  }

  String get allArea {
    return Intl.message('allArea', name: 'allArea', locale: localeName);
  }

  String get additionnalTask {
    return Intl.message('additionnalTask',
        name: 'additionnalTask', locale: localeName);
  }

  String get vehiculeType {
    return Intl.message('vehiculeType',
        name: 'vehiculeType', locale: localeName);
  }

  String get yourOrder {
    return Intl.message('yourOrder', name: 'yourOrder', locale: localeName);
  }

  String get bookingItems {
    return Intl.message('bookingItems',
        name: 'bookingItems', locale: localeName);
  }

  String get erroTimeFrame {
    return Intl.message('erroTimeFrame',
        name: 'erroTimeFrame', locale: localeName);
  }

  String get adressError {
    return Intl.message('adressError', name: 'adressError', locale: localeName);
  }

  String get dateError {
    return Intl.message('dateError', name: 'dateError', locale: localeName);
  }

  String get serviceError {
    return Intl.message('serviceError',
        name: 'serviceError', locale: localeName);
  }

  String get meterError {
    return Intl.message('meterError', name: 'meterError', locale: localeName);
  }

  String get matressTypeError {
    return Intl.message('matressTypeError',
        name: 'matressTypeError', locale: localeName);
  }

  String get deliveryPlace {
    return Intl.message('deliveryPlace',
        name: 'deliveryPlace', locale: localeName);
  }

  String get deliveryPayment {
    return Intl.message('deliveryPayment',
        name: 'deliveryPayment', locale: localeName);
  }

  String get addPaymentMethod {
    return Intl.message('addPaymentMethod',
        name: 'addPaymentMethod', locale: localeName);
  }

  String get bookingInstruction {
    return Intl.message('bookingInstruction',
        name: 'bookingInstruction', locale: localeName);
  }

  String get bookingDate {
    return Intl.message('bookingDate', name: 'bookingDate', locale: localeName);
  }

  String get paymentMod {
    return Intl.message('paymentMod', name: 'paymentMod', locale: localeName);
  }

  String get billing {
    return Intl.message('billing', name: 'billing', locale: localeName);
  }

  String get orderNo {
    return Intl.message('orderNo', name: 'orderNo', locale: localeName);
  }

  String get requiredField {
    return Intl.message('requiredField',
        name: 'requiredField', locale: localeName);
  }

  String get map {
    return Intl.message('map', name: 'map', locale: localeName);
  }

  String get paymentMethod {
    return Intl.message('paymentMethod',
        name: 'paymentMethod', locale: localeName);
  }

  String get serviceEvaluate {
    return Intl.message('serviceEvaluate',
        name: 'serviceEvaluate', locale: localeName);
  }

  String get finish {
    return Intl.message('finish', name: 'finish', locale: localeName);
  }

  String get viewRecept {
    return Intl.message('viewRecept', name: 'viewRecept', locale: localeName);
  }

  String get bookAgain {
    return Intl.message('bookAgain', name: 'bookAgain', locale: localeName);
  }

  String get bookingDone {
    return Intl.message('bookingDone', name: 'bookingDone', locale: localeName);
  }

  String get bookingDoneMessage {
    return Intl.message('bookingDoneMessage',
        name: 'bookingDoneMessage', locale: localeName);
  }

  String get active {
    return Intl.message('active', name: 'active', locale: localeName);
  }

  String get history {
    return Intl.message('history', name: 'history', locale: localeName);
  }

  String get cleaning {
    return Intl.message('cleaning', name: 'cleaning', locale: localeName);
  }

  String get frequency {
    return Intl.message('frequency', name: 'frequency', locale: localeName);
  }

  String get oneTimeWeek {
    return Intl.message('oneTimeWeek', name: 'oneTimeWeek', locale: localeName);
  }

  String get selectDay {
    return Intl.message('selectDay', name: 'selectDay', locale: localeName);
  }

  String get roomSurface {
    return Intl.message('roomSurface', name: 'roomSurface', locale: localeName);
  }

  String get chooseSection {
    return Intl.message('chooseSection',
        name: 'chooseSection', locale: localeName);
  }

  String get carpetSize {
    return Intl.message('carpetSize', name: 'carpetSize', locale: localeName);
  }

  String get location {
    return Intl.message('location', name: 'location', locale: localeName);
  }

  String get useLocation {
    return Intl.message('useLocation', name: 'useLocation', locale: localeName);
  }

  String get pieces {
    return Intl.message('pieces', name: 'pieces', locale: localeName);
  }

  String get abonnement {
    return Intl.message('abonnement', name: 'abonnement', locale: localeName);
  }

  String get ponctualService {
    return Intl.message('ponctualService',
        name: 'ponctualService', locale: localeName);
  }

  String get number {
    return Intl.message('number', name: 'number', locale: localeName);
  }

  String get noNotification {
    return Intl.message('noNotification',
        name: 'noNotification', locale: localeName);
  }

  String get noteservice {
    return Intl.message('noteservice', name: 'noteservice', locale: localeName);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
