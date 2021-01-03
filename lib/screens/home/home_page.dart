import 'file:///C:/Users/msidd/Desktop/projects/VIRTUALDRKIT/lib/services/user.dart';
import 'package:VIRTUALDRKIT/screens/authenticate/sign_in.dart';
import 'package:VIRTUALDRKIT/screens/authenticate/static_components.dart';
import 'package:VIRTUALDRKIT/screens/home/nav_drawer.dart';
import 'package:VIRTUALDRKIT/screens/home/profile_page.dart';
import 'package:VIRTUALDRKIT/services/auth.dart';
import 'package:flutter/material.dart';
import 'tensorflow_testing.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.init();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:cColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: cColors.appbarColor,
        title: Text('DR KIT'),
        elevation: 0.0,
        actions: [
          FlatButton.icon(
              onPressed: () {
       Navigator.push(
           context, MaterialPageRoute(builder: (context) => Tensor()));
              },
              icon: Icon(Icons.settings),
              label: Text('Test'))
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
        backgroundColor: cColors.buttonColor,
      ),
    );
  }
}
