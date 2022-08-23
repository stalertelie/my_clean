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
        "myOrders": MessageLookupByLibrary.simpleMessage("Mes Reservations"),
        "noOrders": MessageLookupByLibrary.simpleMessage("Pas de commandes"),
        "whatService": MessageLookupByLibrary.simpleMessage(
            "De quel service avez-vous besoin aujourd'hui ?"),
        "myBooking": MessageLookupByLibrary.simpleMessage("Réservations"),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "buyCryptoConfirmationText": m0,
        "orderDate": m1,
        "chooseYourCountry":
            MessageLookupByLibrary.simpleMessage("Choisis ton pays"),
        "chooseYourLanguage":
            MessageLookupByLibrary.simpleMessage("Choisis ta langue"),
        "continue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "profileDetailsLabel":
            MessageLookupByLibrary.simpleMessage("Détails du profil"),
        "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
        "myAccount": MessageLookupByLibrary.simpleMessage("PROFIL"),
        "myInvoice": MessageLookupByLibrary.simpleMessage("Mes factures"),
        "helpCenter": MessageLookupByLibrary.simpleMessage("Centre d'aide"),
        "promoCode": MessageLookupByLibrary.simpleMessage("Code promo"),
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
        "welcome": MessageLookupByLibrary.simpleMessage("Bonjour"),
        "chooseService":
            MessageLookupByLibrary.simpleMessage("Choisir un service"),
        "order": MessageLookupByLibrary.simpleMessage("Commander"),
        "furnishedHouse": MessageLookupByLibrary.simpleMessage(
            "Vottre maison  est-elle meublée"),
        "isYourHouseFurnished": MessageLookupByLibrary.simpleMessage(
            "Est ce que c’est une résidence meublée ?"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "isThereAnythingElse": MessageLookupByLibrary.simpleMessage(
            "Y a-t-il autre chose que vous voudriez que nous sachions ?"),
        "enterYourNote":
            MessageLookupByLibrary.simpleMessage("Saisissez votre note ici"),
        "dateAndHour":
            MessageLookupByLibrary.simpleMessage("Choisir la date et l’heure"),
        "whenDoYouWantTheExecution": MessageLookupByLibrary.simpleMessage(
            "A quelle fréquence voulez vous l'exécution du service ?"),
        "selectDate": MessageLookupByLibrary.simpleMessage(
            "Choisir une date et heure (8H-16H)"),
        "selectHour":
            MessageLookupByLibrary.simpleMessage("Choisir une heure (8H-16H)"),
        "addDate": MessageLookupByLibrary.simpleMessage("Ajouter une date"),
        "each": MessageLookupByLibrary.simpleMessage("Chaque"),
        "at": MessageLookupByLibrary.simpleMessage("à"),
        "pleaseChooseAtLeastOneOption": MessageLookupByLibrary.simpleMessage(
            "Veuillez choisir au moins une option avant de passer votre commande"),
        "book": MessageLookupByLibrary.simpleMessage("COMMANDER"),
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
        "passWithoutConnexion":
            MessageLookupByLibrary.simpleMessage("Passer sans se connecter"),
        "noAccount":
            MessageLookupByLibrary.simpleMessage("Vous n'avez pas de compte ?"),
        "signUp": MessageLookupByLibrary.simpleMessage("S'inscrire"),
        "numTel": MessageLookupByLibrary.simpleMessage("Numéro de téléphone"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "selectMatiere":
            MessageLookupByLibrary.simpleMessage("Sélectionnez la matière"),
        "numberPlace": MessageLookupByLibrary.simpleMessage("Nombre de places"),
        "steamCleaning":
            MessageLookupByLibrary.simpleMessage("Nettoyage vapeur"),
        "chooseTypeHouse": MessageLookupByLibrary.simpleMessage(
            "Choisissez votre type de maison"),
        "numberRoom": MessageLookupByLibrary.simpleMessage("Nombre de pièces"),
        "allArea": MessageLookupByLibrary.simpleMessage(
            "Tous les espaces communs sont inclus"),
        "additionnalTask": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez vos tâches supplémentaires"),
        "vehiculeType": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez votre type de véhicule"),
        "yourOrder": MessageLookupByLibrary.simpleMessage("Votre commande"),
        "bookingItems":
            MessageLookupByLibrary.simpleMessage("Article dans votre commande"),
        "erroTimeFrame": MessageLookupByLibrary.simpleMessage(
            "Désolé nous sommes indisponibles"),
        "adressError": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer votre adresse"),
        "dateError":
            MessageLookupByLibrary.simpleMessage("Veuillez choisir une date"),
        "serviceError": MessageLookupByLibrary.simpleMessage(
            "Veuillez ajouter un service svp"),
        "meterError": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir le nombre de mètres"),
        "matressTypeError": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner au moins un type de matelas"),
        "deliveryPlace":
            MessageLookupByLibrary.simpleMessage("Lieu de prestation"),
        "deliveryPayment":
            MessageLookupByLibrary.simpleMessage("Paiement à la livraison"),
        "addPaymentMethod":
            MessageLookupByLibrary.simpleMessage("Ajouter un moyent paiement"),
        "bookingInstruction":
            MessageLookupByLibrary.simpleMessage("Laisser des instructions"),
        "bookingDate":
            MessageLookupByLibrary.simpleMessage("Date de la prestation :"),
        "paymentMod": MessageLookupByLibrary.simpleMessage("Mode de paiement"),
        "billing": MessageLookupByLibrary.simpleMessage("Facturation"),
        "orderNo": MessageLookupByLibrary.simpleMessage("Commande n°"),
        "requiredField": MessageLookupByLibrary.simpleMessage("Champ requis"),
        "map": MessageLookupByLibrary.simpleMessage("Carte"),
        "paymentMethod":
            MessageLookupByLibrary.simpleMessage("Moyen de paiement"),
        "serviceEvaluate":
            MessageLookupByLibrary.simpleMessage("Evaluez la prestation"),
        "finish": MessageLookupByLibrary.simpleMessage("Terminer"),
        "viewRecept": MessageLookupByLibrary.simpleMessage("Voir le reçu"),
        "bookAgain": MessageLookupByLibrary.simpleMessage("Reserver encore"),
        "bookingDone": MessageLookupByLibrary.simpleMessage("Commande ajoutée"),
        "bookingDoneMessage": MessageLookupByLibrary.simpleMessage(
            "Nos agents vous contacterons sous peu."),
        "active": MessageLookupByLibrary.simpleMessage("Actives"),
        "history": MessageLookupByLibrary.simpleMessage("Historiques"),
        "cleaning": MessageLookupByLibrary.simpleMessage("Nettoyage"),
        "frequency": MessageLookupByLibrary.simpleMessage("Fréquence"),
        "oneTimeWeek":
            MessageLookupByLibrary.simpleMessage("1 fois par semaine"),
        "roomSurface":
            MessageLookupByLibrary.simpleMessage("Surface de la pièce"),
        "selectDay": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez le jour de la semaine"),
        "chooseSection":
            MessageLookupByLibrary.simpleMessage("Choisir une section"),
        "carpetSize": MessageLookupByLibrary.simpleMessage(
            "Quelle est la taille de votre tapis ?"),
        "location": MessageLookupByLibrary.simpleMessage("Localisation"),
        "useLocation":
            MessageLookupByLibrary.simpleMessage("Utiliser l'emplacement"),
        "pieces": MessageLookupByLibrary.simpleMessage("PIECES"),
        "abonnement": MessageLookupByLibrary.simpleMessage("ABONNEMENT"),
        "ponctualService": MessageLookupByLibrary.simpleMessage("PONCTUEL"),
        "number": MessageLookupByLibrary.simpleMessage("Nombre"),
        "noNotification": MessageLookupByLibrary.simpleMessage(
            "Aucune notification pour l'instant !"),
        "noteservice": MessageLookupByLibrary.simpleMessage("Noter"),
        "commandDate": MessageLookupByLibrary.simpleMessage("Date commande :"),
        "commandeservice": MessageLookupByLibrary.simpleMessage("Service :"),
        "commandCode": MessageLookupByLibrary.simpleMessage("Code commande : "),
        "witchTime": MessageLookupByLibrary.simpleMessage("Quelle Heure"),
      };
}
