import 'package:my_clean/models/price.dart';
import 'package:my_clean/models/tarification_object.dart';

class TarificationObjectRoot {
  TarificationObjectRoot({
    required this.libelle,
    this.list,
    required this.id
  });

  String libelle;
  String id;
  List<TarificationObject>? list;
}