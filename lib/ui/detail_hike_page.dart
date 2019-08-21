import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/db/hike.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailHikePage extends StatelessWidget {
  final Hike _hike;
  final CloudRepository _cloudRepository;

  DetailHikePage(this._cloudRepository, this._hike, );

  Future<String> getFutureData() async =>
      await Future.delayed(Duration(seconds: 5), () {
        return 'Data Received';
      });

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
                      FutureBuilder(
                          future: _cloudRepository.getUser(_hike.owner),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            } else {
                              return Text(snapshot.data.name,
                                  style: TextStyle(fontStyle: FontStyle.italic));
                            }
                          }
                      ),
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
