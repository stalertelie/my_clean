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
  String get localeName => 'fr';

  static m0(cryptoCode, cryptoAmount, totalAmount) =>
      "Vous avez acheté ${cryptoAmount} ${cryptoCode} pour ${totalAmount}";
  static m1(date) => "Le ${date}";
  static m2(downloadLink) =>
      "Hey! Télécharge l'application MyClean dès maintenant et profites des tarifs de nettoyage concurrentiels: ${downloadLink}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "myOrders": MessageLookupByLibrary.simpleMessage("Mes commandes"),
        "noOrders": MessageLookupByLibrary.simpleMessage("Pas de commandes"),
        "myBooking": MessageLookupByLibrary.simpleMessage("Réservations"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "buyCryptoConfirmationText": m0,
        "orderDate": m1,
        "chooseYourCountry":
            MessageLookupByLibrary.simpleMessage("Choisis ton pays"),
        "chooseYourLanguage":
            MessageLookupByLibrary.simpleMessage("Choisis ton language"),
        "continue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "profileDetailsLabel":
            MessageLookupByLibrary.simpleMessage("Détails du profil"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "myAccount": MessageLookupByLibrary.simpleMessage("Mon compte"),
        "changeLanguage":
            MessageLookupByLibrary.simpleMessage("Changer la langue"),
        "comingSoon":
            MessageLookupByLibrary.simpleMessage("Bientôt disponible"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Changer le mot de passe"),
        "shareApp":
            MessageLookupByLibrary.simpleMessage("Partager l'application"),
        "appDownloadLink": m2,
        "account": MessageLookupByLibrary.simpleMessage("Compte"),
        "home": MessageLookupByLibrary.simpleMessage("Accueil"),
        "youAreNotLogged": MessageLookupByLibrary.simpleMessage(
            "Oups! Vous n'êtes pas connecté"),
        "disconnected": MessageLookupByLibrary.simpleMessage("Déconnecté"),
        "conditionsOfUse":
            MessageLookupByLibrary.simpleMessage("Conditions d'utilisations"),
        "firstNameFieldLabel":
            MessageLookupByLibrary.simpleMessage("Prénom(s)"),
        "lastNameFieldLabel": MessageLookupByLibrary.simpleMessage("Nom"),
        "phone": MessageLookupByLibrary.simpleMessage("Numéro de téléphone"),
        "commune": MessageLookupByLibrary.simpleMessage("Commune"),
        "somethingIsWrongErrorLabel": MessageLookupByLibrary.simpleMessage(
            "Quelquechose s'est mal passé"),
        "welcome": MessageLookupByLibrary.simpleMessage("Bienvenue"),
        "chooseService":
            MessageLookupByLibrary.simpleMessage("Choisir un service"),
        "order": MessageLookupByLibrary.simpleMessage("Commander"),
        "furnishedHouse":
            MessageLookupByLibrary.simpleMessage("Vottre maison  est-elle meublée"),
        "isYourHouseFurnished": MessageLookupByLibrary.simpleMessage(
            "Votre maison est-elle meublée ?"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "isThereAnythingElse": MessageLookupByLibrary.simpleMessage(
            "Y a-t-il autre chose que vous voudriez que nous sachions ?"),
        "enterYourNote":
            MessageLookupByLibrary.simpleMessage("Saisissez votre note ici"),
        "dateAndHour": MessageLookupByLibrary.simpleMessage("Date et heure"),
        "whenDoYouWantTheExecution": MessageLookupByLibrary.simpleMessage(
            "A quel fréquence voulez vous l'exécution du service ?"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Choisir une date"),
        "addDate": MessageLookupByLibrary.simpleMessage("Ajouter une date"),
        "each": MessageLookupByLibrary.simpleMessage("Chaque"),
        "at": MessageLookupByLibrary.simpleMessage("à"),
        "pleaseChooseAtLeastOneOption": MessageLookupByLibrary.simpleMessage(
            "Veuillez choisir au moins une option avant de passer votre commande"),
        "book": MessageLookupByLibrary.simpleMessage("Réserver"),
        "orderSummary":
            MessageLookupByLibrary.simpleMessage("Résumer de la commande"),
        "duration": MessageLookupByLibrary.simpleMessage("Durée"),
        "address": MessageLookupByLibrary.simpleMessage("Adresse"),
        "totalAmountToPay":
            MessageLookupByLibrary.simpleMessage("Montant total à payer"),
        "validate": MessageLookupByLibrary.simpleMessage("Valider"),
        "enterAnAdress":
            MessageLookupByLibrary.simpleMessage("Entrez une adresse"),
        "orderDetails":
            MessageLookupByLibrary.simpleMessage("Détails de la commande"),
        "payCashForExecution": MessageLookupByLibrary.simpleMessage(
            "Payer cash l'exécution du service"),
      };
}
