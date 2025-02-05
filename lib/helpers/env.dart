import 'package:geolocator/geolocator.dart';

enum BuildType {dev, prod}

class Env {
  static Env? _instance;

  static get instance => _instance;

  late BuildType _buildType;
  late Position _position;
  Position get position => _position;

  Env(BuildType buildType, Position position) {
    _buildType = buildType;
    _position = position;
  }

  void setPosition (Position position) {
    _position = position;
  }

  String getServerUri() {
    if(_buildType == BuildType.prod) {
      return 'https://api.kiki-bus.com';
    } else {
      return 'http://kikibus.iptime.org:8080';
    }
  }

  factory Env.fromBuildType(BuildType buildType, Position pos) {
    _instance ??= Env(buildType, pos);
    return _instance!;
  }
}