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
  bool _isready=true;
  List<String> imagePaths;
  List<String> imagedateTime;
  List<String> imagedrLevel;

 getFirebaseImage() async {
   List<String> c;
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseUser user = await _auth.currentUser();
   var ueamil = user.email;
   final StorageReference storageRef = FirebaseStorage.instance.ref().child('images').child('$ueamil');
  dynamic listmp=await storageRef.listAll();
  print(listmp);
   LinkedHashMap allmap=listmp["items"];
   List<dynamic> imagePath=allmap.keys.toList();


   imagePaths=new List(imagePath.length);
   imagedateTime=new List(imagePath.length);
   imagedrLevel=new List(imagePath.length);
   for(int i=0;i<imagePath.length;i++){
     String temp=imagePath[i].toString().split('/').last;
     imagedateTime[i]=temp.substring(0,temp.length-5);
     imagedrLevel[i]=temp.substring(temp.length-5,temp.length-4);
     imagePaths[i]=await storageRef.child(imagePath[i]).getDownloadURL();
   }
   print(imagedateTime);
   print(imagePaths);
setState(() {
  _isready=false;
});

 }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseImage();
    var currDt = DateTime.now();
    print(currDt.day.toString()+'/'+currDt.month.toString()+'/'+currDt.year.toString()+'-'+currDt.hour.toString()+'hours-'+currDt.minute.toString()+'minutes');

  }




  @override
  Widget build(BuildContext context) {

    return
          Scaffold(
           appBar: AppBar(
             title:Text("Your Inbox (History)"),
           ),
            body: _isready?
                Loading():
            Container(
              color: Colors.cyan,
              //margin:EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: (imagePaths.length),
                itemBuilder: (BuildContext context,int index) {
                  return Container(

                    margin: EdgeInsets.only(bottom: 10,top:10,right: 10,left: 10 ),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                      color: Colors.orangeAccent,),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Text("Date and Time: "+imagedateTime[index],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:CachedNetworkImage(
                              height: 400,
                                width: MediaQuery.of(context).size.width,
                                imageUrl: imagePaths[index],
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
                        SizedBox(height: 10,),
                        Text("DR level: "+imagedrLevel[index],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                      ],
                    ),
                  );

                }

              ),
            ),
          );






  }
}

