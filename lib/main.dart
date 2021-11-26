import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/ioc_locator.dart';
import 'package:my_clean/providers/app_provider.dart';
import 'package:my_clean/providers/list_provider.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/splash.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:my_clean/services/localization.dart';

final String DEFAULT_LOCALE = 'fr';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var configuredApp = AppConfig(
    appName: 'My Clean',
    flavorName: 'production',
    apiBaseUrl: 'http://myclean.novate-media.com',
    lockInSeconds: 60,
    version: packageInfo.version,
    child: const MyApp(),
  );
  iocLocator(configuredApp);
  runApp(configuredApp);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final getIt = GetIt.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setupGetIt();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProvider>(
            create: (_) => ListProvider(context)),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'MyClean',
        debugShowCheckedModeBanner: false,
        supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'EN')],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "SFPro"),
        scaffoldMessengerKey: _messangerKey,
        home: SplashScreenPage(),
      ),
    );
  }

  void setupGetIt() async {
    try {
      getIt.registerSingleton<AppServices>(AppServices());
      Future.delayed(const Duration(milliseconds: 300), () {
        print(_messangerKey);
        getIt<AppServices>().setMessengerGlobalKey(_messangerKey);
      });
    } catch (exeption) {
      print(exeption);
    }
  }
}
