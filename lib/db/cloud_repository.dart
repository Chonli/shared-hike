import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_hike/db/user.dart';

class CloudRepository {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CloudRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? Firestore.instance;

  Stream<QuerySnapshot> getHikes() {
    return _firestore.collection('hikes').orderBy('hikeDate').snapshots();
  }

  Future<bool> createHike(
    String title,
    String description,
    DateTime date,
    int distance,
    int elevation,
    String owner,
    String urlImage,) async {
    var ret = true;
    try {
      await _firestore.collection('hikes').add({
        'title': title,
        'description': description,
        'hikeDate': date,
        'owner': owner,
        'elevation': elevation,
        'distance': distance,
        'image': urlImage,
      });
    } catch (error) {
      print(error);
      ret = false;
    }

    return ret;
  }

  Future<User> getUser(String id) {
    return _firestore.collection('users').document(id).get().then((ds) {
      var user=  User.fromSnapshot(ds);
      print(user.toString());
      return user;
    });
  }

  Future<void> createUser({String id, String pseudo}) async {
    return await _firestore.collection('users').document(id).setData({
      'pseudo': pseudo,
    });
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getCurrentUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
