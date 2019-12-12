class Stop {
  int stopId;
  String stopName;
  String longitude;
  String latitude;

  Stop({this.stopId, this.stopName, this.longitude, this.latitude});

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      stopId: json['STOP_ID'],
      stopName: json['STOP_NAME'],
      longitude: json['LONGITUDE'],
      latitude: json['LATITUDE'],
    );
  }
}
