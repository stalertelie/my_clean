import 'package:my_clean/models/price.dart';
import 'package:my_clean/models/tarification_object.dart';

class TarificationObjectRoot {
  TarificationObjectRoot(
      {required this.libelle,
      this.list,
      required this.id,
      this.total = 0});

  String libelle;
  String id;
  int total;
  List<TarificationObject>? list;
}
