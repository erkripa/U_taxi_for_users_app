// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:users_app/src/settings/settings_controller.dart';

class MyApp extends StatefulWidget {
  final Widget? child;
  const MyApp({this.child, this.settingsController});

  final SettingsController? settingsController;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.settingsController!,
      builder: (BuildContext context, Widget? child) {
        return KeyedSubtree(
          key: key,
          child: widget.child!,
        );
      },
    );
  }
}
