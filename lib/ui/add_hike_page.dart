import 'package:flutter/material.dart';
import 'package:shared_hike/ui/hike_form.dart';

class AddHikePage extends StatelessWidget {
  final String _currentUser;

  AddHikePage({Key key, @required String currentUser})
      : _currentUser = currentUser,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout Rando'),
      ),
      body: Center(
        child: HikeForm(currentUser: _currentUser),
      ),
    );
  }
}
