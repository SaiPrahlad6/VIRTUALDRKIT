import 'dart:io';
import 'package:VIRTUALDRKIT/screens/authenticate/static_components.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/0.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/1.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/2.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/3.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Tensor extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Tensorflow",
      home: DR(),
    );
  }

}




class DR extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _DRstate();
  }
}

class _DRstate extends State<DR> {
  List _outputs;
  File _image;
  bool _loading = false;
  bool _pickImage=false;
  StorageReference firebaseStorageRef;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/drd_model.tflite",
      //model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);
    print(output);
    setState(() {
      _loading = false;
      _outputs = output;
    });
    return output;
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value),
      duration: Duration(seconds: 3),
        backgroundColor: cColors.buttonColor,
    ));
  }
  pickImage() async{
    var image;
    if(_pickImage){
    image=await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 512,maxHeight: 512);
    }
    else{
      image = await ImagePicker.pickImage(source: ImageSource.camera,maxWidth: 512,maxHeight: 512);
    }

    final FirebaseUser user = await _auth.currentUser();
    final String uemail=user.email;
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    var out=await classifyImage(_image);
    String _x = out[0]["label"] as String;
    print('the output is:'+_x);
    var currDt = DateTime.now();
    String imgName=currDt.day.toString()+'-'+currDt.month.toString()+'-'+currDt.year.toString()+'-'+currDt.hour.toString()+'hours-'+currDt.minute.toString()+'minutes'+_x;
    print(imgName);
    firebaseStorageRef= FirebaseStorage.instance
        .ref()
        .child('images/$uemail')
        .child(imgName+'.jpg');


    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await (await taskSnapshot).ref.getDownloadURL();
    print(downloadUrl);

    CollectionReference record = Firestore.instance.collection("users").document(user.uid).collection("records").reference();
    await record.add(
        {'dr_level':_x,
    'photoUrl':downloadUrl,
      'date_and_time':currDt.day.toString()+'-'+currDt.month.toString()+'-'+currDt.year.toString()+'-'+currDt.hour.toString()+'hours-'+currDt.minute.toString()+'minutes',
    }
    );

    showInSnackBar("Image Uploaded to storage");

  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _pickImage=true;
                      pickImage();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(9.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _pickImage=false;
                      pickImage();

                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome To DR Test Zone",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: cColors.appbarColor,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _loading
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    //margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null
                            ? Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text("Please select your retinal image ")
                                    ],
                                  ),
                                ),
                              )
                            : Image.file(_image),
                        SizedBox(
                          height: 20,
                        ),
                        _outputs != null
                            ? Text(
                                _outputs[0]["label"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    background: Paint()
                                      ..color = Colors.greenAccent),
                              )
                            : Container(child: Text("")),
                        SizedBox(
                          height: 30.0,
                        ),
                        _image == null
                            ? Container()
                            : RaisedButton(
                                onPressed: () {
                                  //writeOnPdf();
                                  //await savePDF();
                                  //MyHomePage();
                                  String _x = _outputs[0]["label"] as String;
                                  int _answer;
                                  _answer = int.parse(_x);
                                  String one = "1";
                                  String zero = "0";
                                  String two = "2";
                                  String three = "3";
                                  String four = "4";
                                  debugPrint("Dtype clicked");
                                  //debugPrint(_outputs[0]["label"].runtimeType);
                                  debugPrint(_x);
                                  switch (_answer) {
                                    case 0:
                                      {
                                        debugPrint("0");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage0(_image)));
                                      }
                                      break;
                                    case 1:
                                      {
                                        debugPrint("1");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(_image)));
                                      }
                                      break;
                                    case 2:
                                      {
                                        debugPrint("2");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage2(_image)));
                                      }
                                      break;
                                    case 3:
                                      {
                                        debugPrint("3");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage3(_image)));
                                      }
                                      break;
                                    case 4:
                                      {
                                        debugPrint("4");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage4(_image)));
                                      }
                                      break;
                                    default:
                                      {
                                        debugPrint("This is default case");
                                      }
                                      break;
                                  }
                                },
                                padding: const EdgeInsets.all(0.0),
                                color: Colors.greenAccent,
                                child: Text("Generate Prescription"),
                              )
                      ],
                    ),
                  ),
            //SizedBox(
            //height: MediaQuery.of(context).size.height * 0.01,
            //),
            RaisedButton(
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: Icon(
                Icons.add_a_photo,
                size: 20,
                color: Colors.white,
              ),
              color: cColors.buttonColor,
            ),
          ],
        ),
      ),
    );
  }
}
