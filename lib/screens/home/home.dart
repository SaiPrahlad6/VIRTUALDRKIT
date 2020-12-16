import 'package:VIRTUALDRKIT/models/user.dart';
import 'package:VIRTUALDRKIT/screens/authenticate/sign_in.dart';
import 'package:VIRTUALDRKIT/screens/home/MainDrawer.dart';
import 'package:VIRTUALDRKIT/screens/home/PicUpload.dart';
import 'package:VIRTUALDRKIT/services/auth.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text('DR KIT'),
        elevation: 0.0,
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout'))
        ],
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: Center(
        child: const Text('Go to Profile page '),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        },
        label: Text('Profile'),
        icon: Icon(Icons.photo_library),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
