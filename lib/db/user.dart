import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String _id;
  String _name;

  User(this._id, this._name);

  String get id => _id;
  String get name => _name;

  User.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _name = snapshot['pseudo'];
  }

  @override
  String toString() {
    return 'User { id: $_id, name: $_name }';
  }
}