import 'package:attendance_check/helpers/env.dart';
import 'package:flutter/material.dart';

@immutable
class EnvProvider extends InheritedWidget {
  EnvProvider({super.key, required this.buildType, required super.child, });

  final BuildType buildType;

  late Env instance = Env.fromBuildType(buildType);

  static EnvProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EnvProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}
