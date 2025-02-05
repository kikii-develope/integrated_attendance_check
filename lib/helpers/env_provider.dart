import 'package:attendance_check/helpers/env.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

@immutable
class EnvProvider extends InheritedWidget {
  EnvProvider({super.key, required this.buildType, required super.child, required this.position});

  final BuildType buildType;
  final Position position;

  late Env instance = Env.fromBuildType(buildType, position);

  static EnvProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EnvProvider>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}
