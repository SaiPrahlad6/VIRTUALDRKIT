import 'package:VIRTUALDRKIT/screens/authenticate/sign_in.dart';
//import 'package:VIRTUALDRKIT/screens/home/records.dart';
import 'package:VIRTUALDRKIT/screens/home/wallet.dart';
import 'package:VIRTUALDRKIT/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:VIRTUALDRKIT/screens/home/record2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
//import 'package:VIRTUALDRKIT/screens/authenticate/sign_in.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    //final List<dynamic> a = [];
    Future uploadPic(BuildContext context) async {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final FirebaseUser user = await _auth.currentUser();
      final uid = user.uid;
      // Similarly we can get email as well
      final String uemail = user.email;
      print(uid);
      print(uemail);
      final String fileName = basename(_image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('images/$uemail')
          .child(fileName);
      //SignIn.a.add(fileName);
      //print(SignIn.a);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('Image'),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Container(
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
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Color(0xff476cfb),
                          child: ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image != null)
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30.0,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Color(0xff476cfb),
                        onPressed: () {
                          uploadPic(context);
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     // Add your onPressed code here!
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => Center(child: Record2())));
        //   },
        //   label: Text('Records'),
        //   icon: Icon(Icons.photo_library),
        //   backgroundColor: Colors.pink,
        // )
    );
  }
}
