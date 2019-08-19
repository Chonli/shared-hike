import 'package:cloud_firestore/cloud_firestore.dart';

class Hike {
  String _id;
  String _owner;
  String _title;
  String _description;
  String _image;
  int _distance;
  int _elevation;
  int _numberGuest;
  DateTime _hikeDate;

  Hike(this._id, this._title, this._description, this._image, this._elevation, this._distance, this._hikeDate, this._numberGuest, this._owner);

  String get id => _id;
  String get owner => _owner;
  String get title => _title;
  String get description => _description;
  int get distance => _distance;
  int get elevation => _elevation;
  int get numberGuest => _numberGuest;
  DateTime get hikeDate =>  _hikeDate;
  String get image => _image;

  Hike.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _owner = snapshot['owner'];
    _title = snapshot['title'];
    _description = snapshot['description'];
    _distance = snapshot['distance'];
    _elevation = snapshot['elevation'];
    _hikeDate = DateTime.fromMillisecondsSinceEpoch(snapshot['hikeDate'].millisecondsSinceEpoch);
    _image = snapshot['image'];
    _numberGuest = snapshot['numberGuest'];
  }


}