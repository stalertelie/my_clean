import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  const AppConfig({
    Key? key,
    required this.appName,
    required this.apiBaseUrl,
    required this.flavorName,
    required Widget child,
    required this.version,
    required this.lockInSeconds,
  }) : super(key: key, child: child);

  final String appName;
  final String flavorName;
  final String apiBaseUrl;
  final String version;
  final int lockInSeconds;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
