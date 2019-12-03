import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:weathernow/model/PhotoModel.dart';
import 'package:weathernow/model/photo.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  final _model = PhotosModel();
  var _lastInsertedRef;

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }

    // add current time here (firebaseStorageRef)
    Future uploadPic(BuildContext context) async{
      String time = (new DateTime.now().millisecondsSinceEpoch).toString();
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('images/'+time); // add current location here 
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });

      // inserting downlowd url into firestore database for reference
      var url = await firebaseStorageRef.getDownloadURL() as String;
      _lastInsertedRef = await _model.insertPhoto(new Photo(path: url));
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Add Photo'),
        ),
        body: Builder(
        builder: (context) =>  Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(20.0),
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "http://www.stleos.uq.edu.au/wp-content/uploads/2016/08/image-placeholder-350x350.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.file_upload,
                  size: 30.0,
                ),
                onPressed: () {
                  getImage();
                },
              ),
              // Container(
              //   margin: EdgeInsets.all(20.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Text('Location:',
              //           style:
              //               TextStyle(color: Colors.black, fontSize: 18.0)),
              //       SizedBox(width: 20.0),
              //       Text('placeholder',
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 20.0)),
              //     ],
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Cancel',
                      //style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: () {
                     uploadPic(context);
                    },
                                     
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Submit',
                      //style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
              
                ],
              )
            ],
          ),
        ),
        ),
        );
  }
}