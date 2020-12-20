import 'dart:io';

import 'package:VIRTUALDRKIT/screens/home/app_screens/0.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/1.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/2.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/3.dart';
import 'package:VIRTUALDRKIT/screens/home/app_screens/4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

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
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
  }

  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(_image);
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
                      pickImage();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(9.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera();
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Welcome To DR Test Zone",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        backgroundColor: Colors.amber,
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
                                        debugPrint("GeeksforGeeks number 1");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(_image)));
                                      }
                                      break;
                                    case 2:
                                      {
                                        debugPrint("GeeksforGeeks number 2");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage2(_image)));
                                      }
                                      break;
                                    case 3:
                                      {
                                        debugPrint("GeeksforGeeks number 3");
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage3(_image)));
                                      }
                                      break;
                                    case 4:
                                      {
                                        debugPrint("GeeksforGeeks number 4");
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
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
