import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddHikeEvent extends Equatable {
  AddHikeEvent([List props = const []]) : super(props);
}

class TitleChanged extends AddHikeEvent {
  final String title;

  TitleChanged({@required this.title}) : super([title]);

  @override
  String toString() => 'TitleChanged { title :$title }';
}

class DescriptionChanged extends AddHikeEvent {
  final String description;

  DescriptionChanged({@required this.description}) : super([description]);

  @override
  String toString() => 'DescriptionChanged { description: $description }';
}

class DateChanged extends AddHikeEvent {
  final DateTime date;

  DateChanged({@required this.date}) : super([date]);

  @override
  String toString() => 'DescriptionChanged { description: $date }';
}

class DistanceChanged extends AddHikeEvent {
  final int distance;

  DistanceChanged({@required this.distance}) : super([distance]);

  @override
  String toString() => 'DescriptionChanged { description: $distance }';
}

class ElevationChanged extends AddHikeEvent {
  final int elevation;

  ElevationChanged({@required this.elevation}) : super([elevation]);

  @override
  String toString() => 'DescriptionChanged { description: $elevation }';
}

class Submitted extends AddHikeEvent {
  final String title;
  final String description;
  final DateTime date;
  final String owner;
  final int distance;
  final int elevation;

  Submitted(
      {@required this.title,
      @required this.description,
      @required this.date,
      @required this.distance,
      @required this.elevation,
      @required this.owner})
      : super([title, description, date, distance, elevation, owner]);

  @override
  String toString() {
    return 'Submitted { title: $title, description: $description, date: $date, distance: $distance, elevation: $elevation, user: $owner}';
  }
}
