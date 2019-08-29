import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_hike/model/search_image.dart';

class SearchImagePage extends StatefulWidget {
  SearchImagePage({
    Key key,
  }) : super(key: key);

  @override
  _SearchImagePageState createState() => _SearchImagePageState();
}

class _SearchImagePageState extends State<SearchImagePage> {
  final SearchImage searchImage = SearchImage();
  final TextEditingController _filter = TextEditingController();
  String _mQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Recherche Image...',
          ),
          onSubmitted: (query) {
            if (_mQuery != query || query != "") {
              setState(() {
                _mQuery = query;
              });
            }
          },
        ),
      ),
      body: FutureBuilder(
          future: SearchImage().searchImages(_mQuery),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data.length > 0) {
                    return GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return GridTile(
                              child: CachedNetworkImage(
                            imageUrl: snapshot.data[index],
                          ));
                        });
                  } else {
                    return Container();
                  }
                }
            }
          }),
    );
  }
}

//Navigator.of(context).pop();
