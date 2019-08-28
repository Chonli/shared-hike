import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/authentification/register_bloc/bloc.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/authentification/register_form.dart';

class RegisterPage extends StatelessWidget {
  final CloudRepository _cloudRepository;

  RegisterPage({Key key, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null), assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer compte')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          builder: (context) => RegisterBloc(cloudRepository: _cloudRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}