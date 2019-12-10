// City Class
class City {
  int id;
  String name;
  var latitude;
  var longitude;

  City({this.id, this.name, this.latitude, this.longitude});

  City.fromMap(Map<String,dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
  }

  Map<String,dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'latitude': this.latitude,
      'longitude': this.longitude
    };
  }

  @override 
  String toString() {
    return 'Grade{id: $id, sid: $name, grade: $latitude, longitude: $longitude}';
  }
}

