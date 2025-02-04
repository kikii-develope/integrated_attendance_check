enum BuildType {dev, prod}

class Env {
  static Env? _instance;

  static get instance => _instance;

  late BuildType _buildType;  

  Env(BuildType buildType) {
    _buildType = buildType;
  }

  String getServerUri() {
    if(_buildType == BuildType.prod) {
      return 'https://api.kiki-bus.com';
    } else {
      return 'http://kikibus.iptime.org:8080';
    }
  }

  factory Env.fromBuildType(BuildType buildType) {
    _instance ??= Env(buildType);
    return _instance!;
  }
}