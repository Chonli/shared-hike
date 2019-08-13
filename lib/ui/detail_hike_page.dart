import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/db/hike.dart';

class DetailHikePage extends StatelessWidget {
  final Hike _hike;

  DetailHikePage(this._hike);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_hike.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(DateFormat("dd/MM/yyyy").format(_hike.hikeDate)),
            Row(children: [
              Text(_hike.distance.toString()),
              Text("km "),
              Text(_hike.elevation.toString()),
              Text("m")
            ]),
            Padding(
                padding: EdgeInsets.all(8.0), child: Text(_hike.description)),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(_hike.image)),
          ],
        ));
  }
}
