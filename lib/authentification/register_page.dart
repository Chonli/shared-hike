import 'package:flutter/material.dart';
import 'package:shared_hike/authentification/register_form.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer compte')),
      body: Center(
        child: RegisterForm(),
      ),
    );
  }
}
