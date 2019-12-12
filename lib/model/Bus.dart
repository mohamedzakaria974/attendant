class Bus {
  String busId = "";
  String busNumber = "";
  String colorName = "";
  String modelName = "";
  int capacity;
  String busDriverSerial = "";
  String busDriverId = "";
  String busDriverName = "";
  String busDriverDriveDate = "";
  String busDriverEndDate = "";
  String routeSerial = "";
  String routeId = "";
  String busRouteStartTime = "";
  String busRouteArrivalTime = "";

  Bus(
      {this.busId,
      this.busNumber,
      this.colorName,
      this.modelName,
      this.capacity,
      this.busDriverName,
      this.busDriverSerial,
      this.busDriverId,
      this.busDriverDriveDate,
      this.busDriverEndDate,
      this.routeSerial,
      this.routeId,
      this.busRouteStartTime,
      this.busRouteArrivalTime});

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      busId: json['BUS_ID'].toString(),
      busNumber: json['BUS_NUMBER'].toString(),
      colorName: json['COLOR_NAME'].toString(),
      modelName: json['MODEL_NAME'].toString(),
      capacity: json['CAPACITY'],
      busDriverSerial: json['BUS_DRIVER_SERIAL'].toString(),
      busDriverId: json['BUS_DRIVER_DRIVER_ID'].toString(),
      busDriverName: json['BUS_DRIVER_DRIVER_NAME'],
      busDriverDriveDate: json['BUS_DRIVER_DRIVE_DATE'].toString(),
      busDriverEndDate: json['BUS_DRIVER_END_DATE'].toString(),
      busRouteStartTime: json['BUS_ROUT_START_TIME'].toString(),
      busRouteArrivalTime: json['BUS_ROUT_ARRIVAL_TIME'].toString(),
      routeSerial: json['BUS_ROUTE_SERIAL'].toString(),
      routeId: json['ROUTE_ID'].toString(),
    );
  }

  Map toMap() {
    return {
      'BUS_ID': busId,
      'BUS_NUMBER': busNumber,
      'COLOR_NAME': colorName,
      'MODEL_NAME': modelName,
      'CAPACITY': capacity,
      'BUS_DRIVER_SERIAL': busDriverSerial,
      'BUS_DRIVER_DRIVER_ID': busDriverId,
      'BUS_DRIVER_DRIVER_NAME': busDriverName,
      'BUS_DRIVER_DRIVE_DATE': busDriverDriveDate,
      'BUS_DRIVER_END_DATE': busDriverEndDate,
      'BUS_ROUT_START_TIME': busRouteStartTime,
      'BUS_ROUT_ARRIVAL_TIME': busRouteArrivalTime,
      'BUS_ROUTE_SERIAL': routeSerial,
      'ROUTE_ID': routeId,
    };
  }
}
