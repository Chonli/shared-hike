import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_hike/ui/custom_detail_action_button.dart';

class DetailHikePage extends StatelessWidget {
  final String _id;
  final CloudRepository _cloudRepository;

  DetailHikePage(
    this._cloudRepository,
    this._id,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cloudRepository.getHike(_id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(appBar: AppBar(
            title: Text('Chargement...'),
          ),
              body: Center(child: CircularProgressIndicator())
          );
        } else {
          var hike = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(hike.title),
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
                          Text(DateFormat("dd/MM/yyyy").format(hike.hikeDate),
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          FutureBuilder(
                              future: _cloudRepository.getUser(hike.owner),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return Text(snapshot.data.name,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic));
                                }
                              }),
                        ])),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(children: [
                      Text("Distance: ",
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(hike.distance.toString(),
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      Text("km   D+: ",
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      Text(hike.elevation.toString(),
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      Text("m")
                    ])),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(hike.description)),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: hike.image != null
                        ? Hero(
                            tag: 'poster-' + hike.id,
                            child: CachedNetworkImage(
                              imageUrl: hike.image,
                              placeholder: (context, url) =>
                                  new CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  new Container(),
                              cacheManager: DefaultCacheManager(),
                            ))
                        : Container()),
              ],
            ),
            floatingActionButton: CustomDetailActionButton(
                cloudRepository: _cloudRepository, hike: hike),
          );
        }
      },
    );
  }
}
