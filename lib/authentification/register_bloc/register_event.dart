import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: **** }';
}

class PseudoChanged extends RegisterEvent {
  final String pseudo;

  PseudoChanged({@required this.pseudo}) : super([pseudo]);

  @override
  String toString() => 'PseudoChanged { pseudo: $pseudo }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String pseudo;

  Submitted({@required this.email, @required this.password, @required this.pseudo})
      : super([email, password, pseudo]);

  @override
  String toString() {
    return 'Submitted { email: $email, pseudo: $pseudo }';
  }
}