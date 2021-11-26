import 'package:http_interceptor/http_interceptor.dart';
import 'package:my_clean/interceptors/api_language_interceptor.dart';

InterceptedClient initHttpClient() =>
    InterceptedClient.build(interceptors: [ApiLanguageInterceptor()]);
