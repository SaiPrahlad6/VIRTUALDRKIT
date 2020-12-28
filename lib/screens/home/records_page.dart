import 'dart:collection';

import 'package:VIRTUALDRKIT/plugins/mobile_storage.dart';
import 'package:VIRTUALDRKIT/shared/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordsPage extends StatefulWidget {
  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  bool com=true;
  List<String> allImagepaths;

 getFirebaseImage() async {
   List<String> c;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseUser user = await _auth.currentUser();
   var ueamil = user.email;
   final StorageReference storageRef = FirebaseStorage.instance.ref().child('images').child('$ueamil');
  dynamic ty=await storageRef.listAll();
   LinkedHashMap tx=ty["items"];
   List<dynamic> gh=tx.keys.toList();
   allImagepaths=new List(gh.length);
   for(int i=0;i<gh.length;i++){
     allImagepaths[i]=await storageRef.child(gh[i]).getDownloadURL();
   }
setState(() {
  com=false;
});

 }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseImage();

  }




  @override
  Widget build(BuildContext context) {

    return
          Scaffold(
           appBar: AppBar(
             title:Text("Your Inbox"),
           ),
            body: com?
                Loading():
            Container(
              color: Colors.cyan,
              //margin:EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: (allImagepaths.length),
                itemBuilder: (BuildContext context,int index) {
                  return Container(
                    padding:EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(bottom: 10,top:10 ),
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:CachedNetworkImage(
                            imageUrl: allImagepaths[index],
                            placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover)
                        //
                        // Image.network(allImagepaths[index],fit:BoxFit.fill),
                  ),
                  );

                }

              ),
            ),
          );






  }
}

