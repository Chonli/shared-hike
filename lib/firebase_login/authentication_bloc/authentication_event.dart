import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStartedEvent extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedInEvent extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOutEvent extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}