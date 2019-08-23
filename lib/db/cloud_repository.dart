import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_hike/db/user.dart';

import 'hike.dart';

class CloudRepository {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CloudRepository({FirebaseAuth firebaseAuth, Firestore firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? Firestore.instance;

  //Hike method
  Stream<List<Hike>> getHikes() {
    return _firestore.collection('hikes').orderBy('hikeDate').snapshots().map(
        (list) =>
            list.documents.map((ds) => Hike.fromSnapshot(ds)).toList());
  }

  Future<Hike> getHike(String id) {
    return _firestore.collection('hikes').document(id).get().then((ds) {
      var hike = Hike.fromSnapshot(ds);
      return hike;
    });
  }

  Stream<Hike> streamHike(String id) {
    return _firestore
        .collection('hikes')
        .document(id)
        .snapshots()
        .map((snap) => Hike.fromSnapshot(snap));
  }

  Future<bool> createHike(
    String title,
    String description,
    DateTime date,
    int distance,
    int elevation,
    String owner,
    String urlImage,
  ) async {
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

  Future<bool> updateHike(
    Hike hike,
  ) async {
    var ret = true;
    try {
      await _firestore.collection('hikes').document(hike.id).updateData({
        'title': hike.title,
        'description': hike.description,
        'hikeDate': hike.hikeDate,
        'owner': hike.owner,
        'elevation': hike.elevation,
        'distance': hike.distance,
        'image': hike.image,
      });
    } catch (error) {
      print(error);
      ret = false;
    }

    return ret;
  }

  Future<bool> updateMember(String hikeId, String memberId) {
    DocumentReference hikeReference =
        _firestore.collection('hikes').document(hikeId);

    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(hikeReference);
      if (postSnapshot.exists) {
        if (postSnapshot.data['members'] != null) {
          if (!postSnapshot.data['members'].contains(memberId)) {
            await tx.update(hikeReference, <String, dynamic>{
              'members': FieldValue.arrayUnion([memberId])
            });
          } else {
            await tx.update(hikeReference, <String, dynamic>{
              'members': FieldValue.arrayRemove([memberId])
            });
          }
        } else {
          await tx.update(hikeReference, {
            'members': [memberId]
          });
        }
      } else {
        throw Exception("Hike not exist");
      }
    }).then((result) {
      return true;
    }).catchError((error) {
      print('Error: $error');
      return false;
    });
  }

  //User method
  Future<User> getUser(String id) {
    return _firestore
        .collection('users')
        .document(id)
        .get()
        .then((ds) => User.fromSnapshot(ds));
  }

  Stream<User> streamUser(String id) {
    return _firestore
        .collection('users')
        .document(id)
        .snapshots()
        .map((snap) => User.fromSnapshot(snap));
  }

  Future<void> createUser({String id, String pseudo}) async {
    return await _firestore.collection('users').document(id).setData({
      'pseudo': pseudo,
    });
  }

  //Authentification method
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
