import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_hike/db/hike.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'detail_hike_page.dart';

class HikeCard extends StatelessWidget {
  final Hike _hike;

  HikeCard(this._hike);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        Navigator.push(context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => DetailHikePage(_hike)),
            );
      },
    ),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),);
  }
}
