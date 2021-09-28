import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/models/data_response.dart';
import 'package:my_clean/models/frequence.dart';
import 'package:my_clean/utils/request_extension.dart';

class ListProvider extends ChangeNotifier {
  List<Frequence> _frequenceList = [];





  List<Frequence> get frequenceList => _frequenceList;


  String? locale;

  ListProvider(BuildContext context){
    //locale = EasyLocalization.of(context).locale.languageCode;
    locale = 'fr';
    getFrequence();

  }

  getFrequence() {
    RequestExtension<Frequence> _requestExtension = RequestExtension();
    Future<dynamic> response =
    _requestExtension.get(UrlConstant.url_frequence);
    response.then((resp) {
      print('====Fréquence');
      print(resp);
      DataResponse<Frequence> datas = resp as DataResponse<Frequence>;
      //Utils.saveData(AppConstant.USER_LINK, jsonEncode(rep));
      _frequenceList = datas.hydraMember!;
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }



}