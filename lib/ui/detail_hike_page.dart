import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/db/hike.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat("dd/MM/yyyy").format(_hike.hikeDate),
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      //Todo transform owner to name Text(_hike.owner, style: TextStyle(fontStyle: FontStyle.italic)),
                    ])),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [
                  Text("Distance: ",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  Text(_hike.distance.toString(),
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  Text("km   D+: ",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  Text(_hike.elevation.toString(),
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  Text("m")
                ])),
            Padding(
                padding: EdgeInsets.all(8.0), child: Text(_hike.description)),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: _hike.image != null
                    ? Hero(
                        tag: 'poster-' + _hike.id,
                        child: CachedNetworkImage(
                          imageUrl: _hike.image,
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) => new Container(),
                          cacheManager: DefaultCacheManager(),
                        ))
                    : Container()),
          ],
        ));
  }
}
