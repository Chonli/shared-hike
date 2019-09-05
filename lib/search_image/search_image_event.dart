import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchImageEvent extends Equatable {
  SearchImageEvent([List props = const []]) : super(props);
}

class LaunchSearchImageEvent extends SearchImageEvent {
  final String query;

  LaunchSearchImageEvent({@required this.query}) : super([query]);

  @override
  String toString() => 'LaunchSearchImageEvent query: $query';
}