import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:VIRTUALDRKIT/plugins/mobile_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Record2 extends StatefulWidget {
  @override
  _Record2State createState() => _Record2State();
}

class _Record2State extends State<Record2> {
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  List<String> imagepaths = [];
  int index = 0;

  Future<void> getFirebaseImage() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    var ueamil = user.email;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child('images').child('$ueamil');
    //final List x =await storageRef.listAll().then((value) => value["items"]) as List;
    //print(x);
    final List<String> b = await storageRef.listAll().then((result) async {
      dynamic b = result["items"];
      LinkedHashMap a = b;
      List<String> c;
      c = new List(a.length);
      int i = 0;
      a.forEach((key, value) {
        c[i] = (value["path"] as String);
        i++;
      });
      imagepaths = c;
      setState(() {});
    });
    print(b);
  }

  @override
  void initState() {
    super.initState();
    getFirebaseImage();
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> _getImage(BuildContext context, String image) async {
      Image m;
      //List a = await getFirebaseImage();
      //String image = a.first;
      await FireStorageService.loadFromStorage(context, image)
          .then((downloadUrl) {
        m = Image.network(
          downloadUrl.toString(),
          fit: BoxFit.scaleDown,
        );
      });

      return m;
    }

    //var f;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Loading image from Firebase Storage",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: FutureBuilder(
                            future: _getImage(context, imagepaths[index]),
                            builder: (context, snapshot) {
                              //Future<List> _e = getFirebaseImageFolder();
                              //f = _e as List;
                              if (snapshot.connectionState ==
                                  ConnectionState.done)
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.25,
                                  width:
                                      MediaQuery.of(context).size.width / 1.25,
                                  child: snapshot.data,
                                );

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Container(
                                    height: MediaQuery.of(context).size.height /
                                        1.25,
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: CircularProgressIndicator());

                              return Container();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                loadButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loadButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () {
                //fetch another image
                setState(() {
                  final _random = new Random();
                  index = _random.nextInt(imagepaths.length);
                });
              },
              child: Text(
                "Load Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
