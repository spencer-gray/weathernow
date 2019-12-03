import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weathernow/model/PhotoModel.dart';
import 'package:weathernow/model/photo.dart';
// import '../model/grade.dart';
// import '../model/GradeModel.dart';
// import 'grade_form.dart';
import 'package:weathernow/widgets/photo_upload.dart';


class CommunityPhotos extends StatefulWidget {
  CommunityPhotos({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CommunityPhotosState createState() => _CommunityPhotosState();
}

class _CommunityPhotosState extends State<CommunityPhotos> {

   final _model = PhotosModel();
  var _selectedGrade;
  var _selectedIndex = null;
  var _lastInsertedRef;

  final photosList = Firestore.instance.collection('photos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Photos"),
      ),
      // body has a current placeholder, put listGrades in
      body: listGrades(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open photo_upload
          _uploadImagePage(context);
        },
        tooltip: 'New Photo',
        child: Icon(Icons.add),
      ),
      );
  }

  Future<void> _uploadImagePage(BuildContext context) async {
    //Navigator.pop(context);
    
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );

    if (result != null) {
      print(result);
    }
  }

  Widget listGrades(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: photosList.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }   
          return ListView(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            children: snapshot.data.documents.map((data) => photoItem(context, data)).toList(),
          );
        },

      );
  }

  Widget photoItem(BuildContext context, DocumentSnapshot productData) {

    final photo = Photo.fromMap(productData.data, reference: productData.reference);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.symmetric(vertical: 30)),
        GestureDetector(
          child: Container(
            //padding: EdgeInsets.symmetric(vertical: 30),
            // decoration: BoxDecoration(
            //   color: (photo.reference == _selectedIndex) ? Colors.blue : Colors.white,
            // ),
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(20.0),
                child: Image.network(photo.path,
                        //width: 400,
                        //height: 350,
                        fit: BoxFit.fill
                      ),
              ),
              //subtitle: Text('test'),
              // onTap: () {
              //   setState(() { _selectedIndex = photo.reference;
              //                 //_selectedPhoto = photo; 
              //               });
              // }
          )
        ),
      ],
    );
  }
}