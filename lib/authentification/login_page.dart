import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/authentification/login_bloc/login_bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final CloudRepository _cloudRepository;

  LoginPage({Key key, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: LoginForm(cloudRepository: _cloudRepository),
    );
  }
}