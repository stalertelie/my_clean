import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/data_response.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/services.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/request_extension.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc extends BaseBloc {
  Stream<List<Services>> get servicesStream => _servicesSubject.stream;
  final _servicesSubject = BehaviorSubject<List<Services>>();

  BehaviorSubject<List<Services>> get servicesSubject => _servicesSubject;

  HomeBloc() {
    loadServices();
  }


  loadServices() {
    loadingSubject.add(Loading(loading: true));
    RequestExtension<Services> _requestExtension = RequestExtension();
    Future<dynamic> response =
        _requestExtension.get(UrlConstant.url_servies + "?isPrincipal=true");
    //GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    response.then((resp) {
      print("result services");
      print(resp);
      loadingSubject.add(Loading(loading: false));
      //GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
      DataResponse<Services> datas = resp as DataResponse<Services>;
      //Utils.saveData(AppConstant.USER_LINK, jsonEncode(rep));
      print(datas.hydraMember);
      _servicesSubject.add(datas.hydraMember ?? []);
    }).catchError((error) {
      print(error);
      loadingSubject.add(Loading(
          loading: false,
          hasError: true,
          message: "Une erreur c'est produite."));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    });
  }

  Future<User?> getUserInfos() async {
    String? data = await UtilsFonction.getData(AppConstant.USER_INFO);
    final User? user = data != null ? User.fromJson(jsonDecode(data)) : null;
    return user;
  }
}
