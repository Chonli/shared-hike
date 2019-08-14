import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_hike/db/hike.dart';

class CloudRepository {
  final Firestore _firestore;

  CloudRepository({Firestore fireCloud})
      : _firestore = fireCloud ?? Firestore.instance;

  Stream<QuerySnapshot> getHikes() {
    return _firestore.collection('hikes').orderBy('hikeDate').snapshots();
  }

  Future<void> createHike(
    String title,
    String description,
    DateTime date,
    int distance,
    int elevation,
    String owner,
    /*Hike hike*/
  ) async {
    print('Add hike $title to firestore');
    try {
      await _firestore.collection('hikes').add({
        'title': title,
        'description': description,
        'hikeDate': date,
        'owner': owner,
        //'numberGuest': hike.numberGuest,
        'elevation': elevation,
        'distance': distance,
        //'image': hike.image,
      });
/*      await _firestore.collection('hikes').add({
        'title': hike.title,
        'description': hike.description,
        'owner': hike.owner,
        'numberGuest': hike.numberGuest,
        'elevation': hike.elevation,
        'distance': hike.distance,
        'image': hike.image,
        'hikeDate': hike.hikeDate
      });*/
    } catch (error) {
      print(error);
    }
  }
}
