import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/model/hike.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'detail_hike_page.dart';

class HikeCard extends StatelessWidget {
  final Hike _hike;
  final CloudRepository _cloudRepository;

  HikeCard(this._cloudRepository, this._hike);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 5.0,
      child: ListTile(
        leading: Hero(
            tag: 'poster-' + _hike.id,
            child: CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageUrl: _hike.image,
              cacheManager: DefaultCacheManager(),
              height: 55,
            )),
        title: Text(_hike.title),
        subtitle: Text(_hike.description),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
            context,
            _HikeCardPageRoute(cloudRepository: _cloudRepository, id: _hike.id),
          );
        },
      ),
    );
  }
}

class _HikeCardPageRoute extends MaterialPageRoute {
  _HikeCardPageRoute(
      {@required CloudRepository cloudRepository, @required String id})
      : super(
            builder: (context) => DetailHikePage(
                  cloudRepository: cloudRepository,
                  id: id,
                ));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
