import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/fireauth/register_bloc/bloc.dart';
import 'package:shared_hike/fireauth/user_repository.dart';
import 'package:shared_hike/ui/register_form.dart';

class RegisterPage extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer compte')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}