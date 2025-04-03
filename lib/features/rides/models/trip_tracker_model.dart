class TripTrackersModel {
  String? tripId;
  String? driverName;
  double? currentLocationLang;
  double? currentLocationLat;
  String? endLocationFormat;
  double? endLocationLang;
  double? endLocationLat;
  String? fcmToken;
  String? startLocationFormat;
  double? startLocationLang;
  double? startLocationLat;
  String? status;

  TripTrackersModel({
    this.tripId,
    this.driverName,
    this.currentLocationLang,
    this.currentLocationLat,
    this.endLocationFormat,
    this.endLocationLang,
    this.endLocationLat,
    this.fcmToken,
    this.startLocationFormat,
    this.startLocationLang,
    this.startLocationLat,
    this.status
  });

  factory TripTrackersModel.fromJson(Map<String, dynamic> json) => TripTrackersModel(
    tripId: json["tripId"],
    driverName: json["driverName"],
    currentLocationLang: json["currentLocationLang"]?.toDouble(),
    currentLocationLat: json["currentLocationLat"]?.toDouble(),
    endLocationFormat: json["endLocationFormat"],
    endLocationLang: json["endLocationLang"]?.toDouble(),
    endLocationLat: json["endLocationLat"]?.toDouble(),
    fcmToken: json["fcmToken"],
    startLocationFormat: json["startLocationFormat"],
    startLocationLang: json["startLocationLang"]?.toDouble(),
    startLocationLat: json["startLocationLat"]?.toDouble(),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "tripId": tripId,
    "driverName": driverName,
    "currentLocationLang": currentLocationLang,
    "currentLocationLat": currentLocationLat,
    "endLocationFormat": endLocationFormat,
    "endLocationLang": endLocationLang,
    "endLocationLat": endLocationLat,
    "fcmToken": fcmToken,
    "startLocationFormat": startLocationFormat,
    "startLocationLang": startLocationLang,
    "startLocationLat": startLocationLat,
    "status": status,
  };
}
