// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ioc/ioc.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/http_client_config.dart';
import 'package:my_clean/services/booking_api.dart';
import 'package:my_clean/services/current_user_api.dart';
import 'package:my_clean/services/safe_secure_storage.dart';

void iocLocator(AppConfig config) {
  Ioc().bind('bookingApi',
      (ioc) => BookingApi(config: config, client: initHttpClient()));
  Ioc().bind('currentUserApi',
      (ioc) => CurrentUserApi(config: config, client: initHttpClient()));
  Ioc().bind('secureStorage',
      (ioc) => SafeSecureStorage(const FlutterSecureStorage()));
}
