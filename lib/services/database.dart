import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });
  final CollectionReference record = Firestore.instance.collection("records");
  Future updateUserData(String disease, String name, int strength) async {
    print(uid);
    return await record.document(uid).setData({
      'disease': disease,
      'name': name,
      'strength': strength,
    });
  }
}
