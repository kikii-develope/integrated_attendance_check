class QrData {
  double latitude;
  double longitude;
  
  QrData ({this.latitude = 37.4048585, this.longitude = 127.1059857});

  @override
  String toString() {
    return '{ latitude: $latitude, longitude: $longitude}';
  }
}