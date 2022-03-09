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

  String get noOrders {
    return Intl.message('noOrders', name: 'noOrders', locale: localeName);
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