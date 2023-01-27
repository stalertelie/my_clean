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
        "myBooking": MessageLookupByLibrary.simpleMessage("Bookings"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "noOrders": MessageLookupByLibrary.simpleMessage("No orders"),
        "whatService": MessageLookupByLibrary.simpleMessage(
            "What service do you need today ?"),
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
        "myAccount": MessageLookupByLibrary.simpleMessage("My profile"),
        "myInvoice": MessageLookupByLibrary.simpleMessage("My invoice"),
        "helpCenter": MessageLookupByLibrary.simpleMessage("Help center"),
        "promoCode": MessageLookupByLibrary.simpleMessage("Promo code"),
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
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
        "deleteAccountConfirm": MessageLookupByLibrary.simpleMessage(
            "Do you really want to delete your account?"),
        "conditionsOfUse":
            MessageLookupByLibrary.simpleMessage("Conditions of use"),
        "firstNameFieldLabel":
            MessageLookupByLibrary.simpleMessage("Firstname"),
        "lastNameFieldLabel": MessageLookupByLibrary.simpleMessage("Lastname"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone number"),
        "commune": MessageLookupByLibrary.simpleMessage("Town"),
        "somethingIsWrongErrorLabel":
            MessageLookupByLibrary.simpleMessage("Something went wrong"),
        "welcome": MessageLookupByLibrary.simpleMessage("Hi"),
        "chooseService":
            MessageLookupByLibrary.simpleMessage("Choose a service"),
        "order": MessageLookupByLibrary.simpleMessage("Order"),
        "furnishedHouse":
            MessageLookupByLibrary.simpleMessage("Furnished house"),
        "isYourHouseFurnished": MessageLookupByLibrary.simpleMessage(
            "Is it a furnished residence??"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "isThereAnythingElse": MessageLookupByLibrary.simpleMessage(
            "Is there anything else you would like us know?"),
        "enterYourNote":
            MessageLookupByLibrary.simpleMessage("Enter your note here"),
        "dateAndHour":
            MessageLookupByLibrary.simpleMessage("Choose the date and time"),
        "whenDoYouWantTheExecution": MessageLookupByLibrary.simpleMessage(
            "How often do you want the execution of the service?"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Select a date"),
        "selectHour":
            MessageLookupByLibrary.simpleMessage("Select an hour (8AM:4PM)"),
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
        "passWithoutConnexion":
            MessageLookupByLibrary.simpleMessage("Pass without log in"),
        "noAccount":
            MessageLookupByLibrary.simpleMessage("You don't have an account ?"),
        "signUp": MessageLookupByLibrary.simpleMessage("Signup"),
        "numTel": MessageLookupByLibrary.simpleMessage("Phone number"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "selectMatiere":
            MessageLookupByLibrary.simpleMessage("Select the material"),
        "numberPlace": MessageLookupByLibrary.simpleMessage("Number of seats"),
        "steamCleaning": MessageLookupByLibrary.simpleMessage("Steam cleaning"),
        "chooseTypeHouse":
            MessageLookupByLibrary.simpleMessage("Choose your type of house"),
        "numberRoom": MessageLookupByLibrary.simpleMessage("Number of rooms"),
        "allArea": MessageLookupByLibrary.simpleMessage(
            "All common areas are included"),
        "additionnalTask": MessageLookupByLibrary.simpleMessage(
            "Select your additional tasks"),
        "vehiculeType":
            MessageLookupByLibrary.simpleMessage("Select your vehicle type"),
        "yourOrder": MessageLookupByLibrary.simpleMessage("Your order"),
        "bookingItems":
            MessageLookupByLibrary.simpleMessage("Item in your order"),
        "pleaseChooseOne": MessageLookupByLibrary.simpleMessage(
            "Please select at least one option before placing your order"),
        "erroTimeFrame": MessageLookupByLibrary.simpleMessage(
            "We do not provide services in this time frame."),
        "adressError":
            MessageLookupByLibrary.simpleMessage("Please enter your address"),
        "dateError":
            MessageLookupByLibrary.simpleMessage("Please select a date"),
        "serviceError":
            MessageLookupByLibrary.simpleMessage("Please add a service"),
        "meterError": MessageLookupByLibrary.simpleMessage(
            "Please enter the number of meters"),
        "matressTypeError": MessageLookupByLibrary.simpleMessage(
            "Please select at least one type of mattress"),
        "deliveryPlace":
            MessageLookupByLibrary.simpleMessage("Place of delivery"),
        "deliveryPayment":
            MessageLookupByLibrary.simpleMessage("Payment on delivery"),
        "addPaymentMethod":
            MessageLookupByLibrary.simpleMessage("Add a payment method"),
        "bookingInstruction":
            MessageLookupByLibrary.simpleMessage("Leave instructions"),
        "bookingDate": MessageLookupByLibrary.simpleMessage("Date of service:"),
        "paymentMod": MessageLookupByLibrary.simpleMessage("Method of payment"),
        "billing": MessageLookupByLibrary.simpleMessage("Billing"),
        "orderNo": MessageLookupByLibrary.simpleMessage("Order No."),
        "requiredField": MessageLookupByLibrary.simpleMessage("Required field"),
        "map": MessageLookupByLibrary.simpleMessage("Map"),
        "paymentMethod": MessageLookupByLibrary.simpleMessage("Payment method"),
        "serviceEvaluate":
            MessageLookupByLibrary.simpleMessage("Evaluate the service"),
        "finish": MessageLookupByLibrary.simpleMessage("Finish"),
        "viewRecept": MessageLookupByLibrary.simpleMessage("View receipt"),
        "bookAgain": MessageLookupByLibrary.simpleMessage("Book again"),
        "bookingDone":
            MessageLookupByLibrary.simpleMessage("Order successfully added"),
        "bookingDoneMessage": MessageLookupByLibrary.simpleMessage(
            "Our agents will contact you shortly"),
        "active": MessageLookupByLibrary.simpleMessage("Active"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "cleaning": MessageLookupByLibrary.simpleMessage("Cleaning"),
        "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
        "oneTimeWeek": MessageLookupByLibrary.simpleMessage("1 time per week"),
        "selectDay":
            MessageLookupByLibrary.simpleMessage("Select the day of the week"),
        "roomSurface":
            MessageLookupByLibrary.simpleMessage("Surface of the room"),
        "chooseSection":
            MessageLookupByLibrary.simpleMessage("Choose a section"),
        "carpetSize": MessageLookupByLibrary.simpleMessage(
            "What is the size of your carpet?"),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "useLocation": MessageLookupByLibrary.simpleMessage("Use location"),
        "pieces": MessageLookupByLibrary.simpleMessage("ROOMS"),
        "abonnement": MessageLookupByLibrary.simpleMessage("SUBSCRIPTION"),
        "ponctualService": MessageLookupByLibrary.simpleMessage("PONCTUAL"),
        "number": MessageLookupByLibrary.simpleMessage("Number"),
        "noNotification":
            MessageLookupByLibrary.simpleMessage("No notification yet!"),
        "noteservice": MessageLookupByLibrary.simpleMessage("Rate"),
        "commandDate": MessageLookupByLibrary.simpleMessage("Command date :"),
        "commandeservice": MessageLookupByLibrary.simpleMessage("Service :"),
        "commandCode": MessageLookupByLibrary.simpleMessage("Booking code : "),
        "witchTime": MessageLookupByLibrary.simpleMessage("Which time"),
        "myNotification":
            MessageLookupByLibrary.simpleMessage("My notifications"),
        "payCashAfterService":
            MessageLookupByLibrary.simpleMessage("Pay in cash"),
        "commandRecap": MessageLookupByLibrary.simpleMessage("Summary"),
        "prix": MessageLookupByLibrary.simpleMessage("Amount"),
        "recurrentPassage":
            MessageLookupByLibrary.simpleMessage("Recurrent passage"),
        "bySemain": MessageLookupByLibrary.simpleMessage("once a week"),
        "receipt": MessageLookupByLibrary.simpleMessage("Receipt MyClean"),
      };
}
