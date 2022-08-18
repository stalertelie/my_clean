import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/extensions/extensions.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/evaluation.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/utils/request_extension.dart';

class EvaluateBloc extends BaseBloc {
  void evaluate(Evaluation evaluation) {
    RequestExtension<Evaluation> requestExtension = RequestExtension();

    loadingSubject
        .add(Loading(loading: true, message: "Soumission en cours..."));

    GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    Future<dynamic> response =
        requestExtension.post("evaluations", jsonEncode(evaluation));

    response.then((value) async {
      loadingSubject.add(Loading(
          message: MessageConstant.evaluation_ok,
          hasError: false,
          loading: false));
    }).catchError((error) {
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    });
  }
}
