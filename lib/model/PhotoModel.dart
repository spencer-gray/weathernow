import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'photo.dart';

class PhotosModel {  
  Future<DocumentReference> insertPhoto(Photo photo) async {

    CollectionReference photos = Firestore.instance.collection('photos');

    return await photos.add(photo.toMap());
  }

  Future<void> updatePhoto(Photo photo, String path) async {
    return await photo.reference.updateData({'path': path});
  }

  Future<void> deletePhoto(Photo photo) async {
    return photo.reference.delete();
  }
}