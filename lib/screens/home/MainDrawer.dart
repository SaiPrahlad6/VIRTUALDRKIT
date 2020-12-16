import 'package:VIRTUALDRKIT/screens/home/PicUpload.dart';
import 'package:VIRTUALDRKIT/screens/home/Tensorflow.dart';
import 'package:VIRTUALDRKIT/screens/home/Tensorflow_Lite.dart';
import 'package:VIRTUALDRKIT/screens/home/chatbot.dart';
import 'package:VIRTUALDRKIT/screens/home/record2.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("assets/doctor2.jpg"),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "HOME",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "VIRTUAL DR KIT",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        },
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text("Your Profile"),
      ),

      ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Record2()));
        },
        leading: Icon(
          Icons.inbox,
          color: Colors.black,
        ),
        title: Text("Your Inbox"),
      ),

      ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatBot()));
        },
        leading: Icon(
          Icons.assessment,
          color: Colors.black,
        ),
        title: Text("HelpDesk"),
      ),

      ListTile(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Tensor()));
        },
        leading: Icon(
          Icons.settings,
          color: Colors.black,
        ),
        title: Text("TEST"),
      ),
    ]);
  }
}
