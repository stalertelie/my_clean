// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(cryptoCode, cryptoAmount, totalAmount) =>
      "You bought ${cryptoAmount} ${cryptoCode} for ${totalAmount}";
  static m1(date) => "${date}";
  static m2(downloadLink) =>
      "Hey! Download the MyClean app now and take advantage of competitive cleaning rates: ${downloadLink}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "myOrders": MessageLookupByLibrary.simpleMessage("My orders"),
        "noOrders": MessageLookupByLibrary.simpleMessage("No orders"),
        "buyCryptoConfirmationText": m0,
        "orderDate": m1,
        "chooseYourCountry":
            MessageLookupByLibrary.simpleMessage("Choose your country"),
        "chooseYourLanguage":
            MessageLookupByLibrary.simpleMessage("Choose your language"),
        "continue": MessageLookupByLibrary.simpleMessage("Continue"),
        "profileDetailsLabel":
            MessageLookupByLibrary.simpleMessage("Profile details"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "myAccount": MessageLookupByLibrary.simpleMessage("My account"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Change the language"),
        "comingSoon": MessageLookupByLibrary.simpleMessage("Coming soon"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change password"),
        "shareApp": MessageLookupByLibrary.simpleMessage("Share the app"),
        "appDownloadLink": m2,
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "youAreNotLogged": MessageLookupByLibrary.simpleMessage(
            "Whoops! You are not connected"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
        "conditionsOfUse":
            MessageLookupByLibrary.simpleMessage("Conditions of use"),
        "firstNameFieldLabel":
            MessageLookupByLibrary.simpleMessage("Firstname"),
        "lastNameFieldLabel": MessageLookupByLibrary.simpleMessage("Lastname"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone number"),
        "commune": MessageLookupByLibrary.simpleMessage("Town"),
        "somethingIsWrongErrorLabel":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "welcome": MessageLookupByLibrary.simpleMessage("Welcome"),
        "chooseService":
            MessageLookupByLibrary.simpleMessage("Choose a service"),
        "order": MessageLookupByLibrary.simpleMessage("Order"),
        "furnishedHouse":
            MessageLookupByLibrary.simpleMessage("Furnished house"),
        "isYourHouseFurnished":
            MessageLookupByLibrary.simpleMessage("Is your house furnished?"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "isThereAnythingElse": MessageLookupByLibrary.simpleMessage(
            "Is there anything else you would like us know?"),
        "enterYourNote":
            MessageLookupByLibrary.simpleMessage("Enter your note here"),
        "dateAndHour": MessageLookupByLibrary.simpleMessage("Date and hour"),
        "whenDoYouWantTheExecution": MessageLookupByLibrary.simpleMessage(
            "When do you want the execution of the service?"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Select a date"),
        "addDate": MessageLookupByLibrary.simpleMessage("Add a date"),
        "each": MessageLookupByLibrary.simpleMessage("Each"),
        "at": MessageLookupByLibrary.simpleMessage("at"),
        "pleaseChooseAtLeastOneOption": MessageLookupByLibrary.simpleMessage(
            "Please choose at least one option before placing your order"),
        "book": MessageLookupByLibrary.simpleMessage("Book"),
        "orderSummary": MessageLookupByLibrary.simpleMessage("Order summary"),
        "duration": MessageLookupByLibrary.simpleMessage("Duration"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "totalAmountToPay":
            MessageLookupByLibrary.simpleMessage("Total amount to pay"),
        "validate": MessageLookupByLibrary.simpleMessage("Validate"),
        "enterAnAdress":
            MessageLookupByLibrary.simpleMessage("Enter an address"),
        "orderDetails":
            MessageLookupByLibrary.simpleMessage("Details of the order"),
        "payCashForExecution": MessageLookupByLibrary.simpleMessage(
            "Pay cash for the execution of the service"),
      };
}
