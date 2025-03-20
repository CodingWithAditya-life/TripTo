class PredictionPlaces{
  String? place_id;
  String? main_text;
  String? secondary_text;

  PredictionPlaces({this.place_id, this.main_text, this.secondary_text});

  PredictionPlaces.fromJson(Map<String,dynamic> jsonData){
    place_id = jsonData['place_id'];
    main_text = jsonData['structured_formatting']['secondary_text'];
  }
}
