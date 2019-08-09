import 'package:cloud_firestore/cloud_firestore.dart';

class Hike {
  String _id;
  String _title;
  String _description;
  String _image;
  int _distance;
  int _elevation;
  DateTime _releaseDate;

  Hike(this._id, this._title, this._description, this._image, this._elevation, this._distance, this._releaseDate);

  String get id => _id;
  String get title => _title;
  String get description => _description;
  int get distance => _distance;
  int get elevation => _elevation;
  DateTime get releaseDate =>  _releaseDate;
  String get image => _image;

  Hike.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _title = snapshot['title'];
    _description = snapshot['description'];
    _distance = snapshot['distance'];
    _elevation = snapshot['elevation'];
    //_releaseDate = snapshot['release_date'];
    _image = snapshot['image'];
  }


}