import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_hike/model/hike.dart';

@immutable
abstract class HikeEvent extends Equatable {
  HikeEvent([List props = const []]) : super(props);
}

class TitleChanged extends HikeEvent {
  final String title;

  TitleChanged({@required this.title}) : super([title]);

  @override
  String toString() => 'TitleChanged { title :$title }';
}

class DescriptionChanged extends HikeEvent {
  final String description;

  DescriptionChanged({@required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description: $description }';
}

class DateChanged extends HikeEvent {
  final DateTime date;

  DateChanged({@required this.date}) : super([date]);

  @override
  String toString() => 'DescriptionChanged { description: $date }';
}

class DistanceChanged extends HikeEvent {
  final int distance;

  DistanceChanged({@required this.distance}) : super([distance]);

  @override
  String toString() => 'DescriptionChanged { description: $distance }';
}

class ElevationChanged extends HikeEvent {
  final int elevation;

  ElevationChanged({@required this.elevation}) : super([elevation]);

  @override
  String toString() => 'DescriptionChanged { description: $elevation }';
}

class UrlImageChanged extends HikeEvent {
  final String urlImage;

  UrlImageChanged({@required this.urlImage}) : super([urlImage]);

  @override
  String toString() => 'DescriptionChanged { description: $urlImage }';
}

class CreateHikeEvent extends HikeEvent {
  final String title;
  final String description;
  final DateTime date;
  final String owner;
  final int distance;
  final int elevation;
  final String urlImage;

  CreateHikeEvent(
      {@required this.title,
      @required this.description,
      @required this.date,
      @required this.distance,
      @required this.elevation,
      @required this.owner,
      @required this.urlImage})
      : super([title, description, date, distance, elevation, owner, urlImage]);

  @override
  String toString() {
    return 'CreateHikeEvent { title: $title, description: $description, date: $date, distance: $distance, elevation: $elevation, user: $owner}';
  }
}

class UpdateHikeEvent extends HikeEvent {
  final Hike hike;

  UpdateHikeEvent({@required this.hike}) : super([hike]);

  @override
  String toString() {
    return 'UpdateHikeEvent { title: ${hike.title}, description: ${hike.description}, date: ${hike.hikeDate}, distance: ${hike.distance}, elevation: ${hike.elevation}}';
  }
}

class MembersUpdateEvent extends HikeEvent {
  final String memberId;
  final String hikeId;

  MembersUpdateEvent({@required this.hikeId, @required this.memberId})
      : super([hikeId, memberId]);

  @override
  String toString() => 'MembersUpdateEvent { hike: $hikeId, member: $memberId }';
}
