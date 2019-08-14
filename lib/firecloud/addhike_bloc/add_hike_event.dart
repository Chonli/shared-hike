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

class Submitted extends AddHikeEvent {
  final String title;
  final String description;

  Submitted({@required this.title, @required this.description})
      : super([title, description]);

  @override
  String toString() {
    return 'Submitted { title: $title, description: $description }';
  }
}