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
          print("query=$query");
          searchImage.searchImages(query);
        },
      ),
    ));
  }
}

//Navigator.of(context).pop();
