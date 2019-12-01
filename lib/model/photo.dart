import 'package:cloud_firestore/cloud_firestore.dart';

// Photo model for storing user's images
class Photo {
  String path;
  //String location;
  DocumentReference reference;

  Photo({this.path});

  Photo.fromMap(Map<String,dynamic> map, {this.reference}) {
    this.path = map['path'];
  }

  Map<String,dynamic> toMap() {
    return {
      'path': this.path,
    };
  }

  @override 
  String toString() {
    return 'Photo{path: $path}';
  }
}

