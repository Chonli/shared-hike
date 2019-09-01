import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchImageState extends Equatable {
  SearchImageState([List props = const []]) : super(props);
}

class SearchImageInitialState  extends SearchImageState {
  @override
  String toString() => 'SearchImageInitialState';
}

class SearchImageLoadingState  extends SearchImageState {
  @override
  String toString() => 'SearchImageLoadingState';
}

class SearchImageSuccessState extends SearchImageState {
  final List<String> urlResult;

  SearchImageSuccessState(this.urlResult) : super([urlResult]);

  @override
  String toString() => 'SearchImageSuccessState { urlResult: $urlResult }';
}

class SearchImageErrorState  extends SearchImageState {
  @override
  String toString() => 'SearchImageErrorState';
}

class ResultSearchSuccessState  extends SearchImageState {
  final String urlResult;

  ResultSearchSuccessState(this.urlResult) : super([urlResult]);

  @override
  String toString() => 'ResultSearchSuccessState { urlResult: $urlResult }';
}

class ResultSearchErrorState  extends SearchImageState {

  @override
  String toString() => 'ResultSearchErrorState';
}