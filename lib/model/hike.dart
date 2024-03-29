import 'package:cloud_firestore/cloud_firestore.dart';

class Hike {
  String _id;
  String _owner;
  String _title;
  String _description;
  String _image;
  int _distance;
  int _elevation;
  DateTime _hikeDate;
  List<String> _members;

  Hike(this._id, this._title, this._description, this._image, this._elevation, this._distance, this._hikeDate, this._owner);

  String get id => _id;
  String get owner => _owner;
  String get title => _title;
  String get description => _description;
  int get distance => _distance;
  int get elevation => _elevation;
  DateTime get hikeDate =>  _hikeDate;
  String get image => _image;
  List<String> get members => _members;

  Hike.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.documentID;
    _owner = snapshot['owner'];
    _title = snapshot['title'];
    _description = snapshot['description'];
    _distance = snapshot['distance'];
    _elevation = snapshot['elevation'];
    _hikeDate = DateTime.fromMillisecondsSinceEpoch(snapshot['hikeDate'].millisecondsSinceEpoch);
    _image = snapshot['image'];
    if(snapshot['members'] != null) {
      _members = List<String>.from(snapshot['members']);
    }else{
      _members = [];
    }
  }


}