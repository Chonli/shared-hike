import 'package:flutter/material.dart';
import 'package:shared_hike/model/hike.dart';
import 'package:shared_hike/ui/hike_form.dart';

class EditHikePage extends StatelessWidget {
  final Hike _hike;

  EditHikePage({Key key, @required Hike hike})
      : assert(hike != null),
        _hike = hike,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout Rando'),
      ),
      body: Center(
        child: HikeForm(
          hike: _hike,
        ),
      ),
    );
  }
}
