import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_hike/model/hike.dart';
import 'package:shared_hike/firecloud/hike_bloc/bloc.dart';
import 'package:shared_hike/ui/edit_hike_page.dart';
import 'package:provider/provider.dart';

class DetailHikePage extends StatefulWidget {
  final String _id;

  DetailHikePage({Key key, @required String id})
      : assert(id != null),
        _id = id,
        super(key: key);

  State<DetailHikePage> createState() => _DetailHikePageState();
}

class _DetailHikePageState extends State<DetailHikePage> {
  String get _id => widget._id;
  CloudRepository _cloudRepository;

  HikeBloc _hikeBloc;
  String _currentId = "";

  @override
  void initState() {
    super.initState();
    _cloudRepository = Provider.of<CloudRepository>(context, listen: false);
    _hikeBloc = BlocProvider.of<HikeBloc>(context);
    _cloudRepository.getCurrentUserId().then((currentId) {
      setState(() {
        _currentId = currentId;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cloudRepository.streamHike(_id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Chargement...'),
              ),
              body: Center(child: CircularProgressIndicator()));
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
                          StreamBuilder(
                              stream: _cloudRepository.streamUser(hike.owner),
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Distance: " +
                                  (hike.distance / 1000.0).toString() +
                                  "km",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          Text("D+: " + hike.elevation.toString() + "m",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          Row(// Replace with a Row for horizontal icon + text
                              children: <Widget>[
                            Text(hike.members.length.toString() + " "),
                            Icon(Icons.group),
                          ]),
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
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Container(),
                              cacheManager: DefaultCacheManager(),
                            ))
                        : Container()),
              ],
            ),
            floatingActionButton: getFloatingButton(hike),
          );
        }
      },
    );
  }

  Widget getFloatingButton(Hike hike) {
    return hike.owner == _currentId
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditHikePage(
                            hike: hike,
                          )));
            },
            tooltip: 'Modifier',
            child: Icon(Icons.edit))
        : hike.hikeDate.isAfter(DateTime.now())
            ? FloatingActionButton(
                onPressed: () {
                  _hikeBloc.dispatch(MembersUpdateEvent(
                      hikeId: hike.id, memberId: _currentId));
                },
                tooltip: hike.members.contains(_currentId)
                    ? 'Quitter'
                    : 'Participer',
                child: hike.members.contains(_currentId)
                    ? Icon(Icons.clear)
                    : Icon(Icons.group_add))
            : null;
  }
}
