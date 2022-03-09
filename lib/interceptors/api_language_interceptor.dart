import 'dart:io';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:my_clean/services/localization.dart';

class ApiLanguageInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      data.headers[HttpHeaders.acceptLanguageHeader] = AppLocalizations.current.localeName;
    } catch (exception) {
      print('Exception occurred while adding Language Header:');
      print(exception);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
