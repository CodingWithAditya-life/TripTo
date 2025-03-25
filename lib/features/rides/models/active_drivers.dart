class ActiveModel {
  String? id;
  ActiveDriverModel? driver;
  String? city;

  ActiveModel({
    this.id,
    this.driver,
    this.city,
  });

  factory ActiveModel.fromJson(Map<String, dynamic> json) => ActiveModel(
    id: json["id"],
    driver: json["driver"] == null ? null : ActiveDriverModel.fromJson(json["driver"]),
    city: json["city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver": driver?.toJson(),
    "city": city,
  };
}

class ActiveDriverModel {
  String? id;
  String? fullName;
  String? location;
  ActiveVehicleModel? vehicle;
  String? fcmToken;
  double? lat;
  double? lang;

  ActiveDriverModel({
    this.id,
    this.fullName,
    this.location,
    this.vehicle,
    this.fcmToken,
    this.lat,
    this.lang
  });

  factory ActiveDriverModel.fromJson(Map<String, dynamic> json) => ActiveDriverModel(
      id: json["id"],
      fullName: json["fullName"],
      location: json["location"],
      vehicle: json["vehicle"] == null ? null : ActiveVehicleModel.fromJson(json["vehicle"]),
      fcmToken: json['fcmToken'],
      lang: json['lang'],
      lat: json['lat']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "location": location,
    "vehicle": vehicle?.toJson(),
    "fcmToken": fcmToken,
    "lang" : lang,
    "lat" : lat
  };
}

class ActiveVehicleModel {
  String? id;
  String? name;
  String? type;
  String? color;
  String? imageUrl;
  String? price;
  bool? isOnline;

  ActiveVehicleModel({
    this.id,
    this.name,
    this.type,
    this.color,
    this.imageUrl,
    this.price,
    this.isOnline
  });

  factory ActiveVehicleModel.fromJson(Map<String, dynamic> json) => ActiveVehicleModel(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      color: json["color"],
      imageUrl: json["imageUrl"],
      price: json["price"],
      isOnline: json['isOnline']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "color": color,
    "imageUrl": imageUrl,
    "price": price,
    "isOnline" :isOnline
    };
}