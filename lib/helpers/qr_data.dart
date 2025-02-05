class QrData {
  double latitude;
  double longitude;
  
  QrData ({double? latitude , double? longitude }) 
    : latitude = latitude ?? 37.4048585,
      longitude = longitude ?? 127.1058957
    ;

  @override
  String toString() {
    return '{ latitude: $latitude, longitude: $longitude}';
  }
}