import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class UninitializedState  extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class AuthenticatedState  extends AuthenticationState {
  final String displayName;

  AuthenticatedState(this.displayName) : super([displayName]);

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}

class UnauthenticatedState  extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
