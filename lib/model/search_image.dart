import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class SearchImage {
  final urlAPI = "https://pixabay.com/api/?";
  final _ResultSearchCache _cache = _ResultSearchCache();
  var _key = "";
  bool isInit = false;

  static final SearchImage _singleton = SearchImage._internal();

  SearchImage._internal();

  factory SearchImage() {
    return _singleton;
  }

  _initService() async{
    if(!isInit) {
      final jsonString = await rootBundle.loadString("secret.json");
      final jsonResponse = json.decode(jsonString);
      _key = jsonResponse['api_search_image_key'];
      isInit = true;
    }
  }

  Future<List<String>> searchImages(String query) async {
    await _initService();

    if(query.isNotEmpty) {
      final _query = query.replaceAll(' ', '+');
      if (_cache.contains(_query)) {
        return _cache.get(_query);
      } else {
        var client = new http.Client();
        print("Search : " + urlAPI + "key=$_key&q=$_query&image_type=photo");
        var response = await client.get(
            urlAPI + "key=$_key&q=$_query&image_type=photo");

        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          List<String> result = [];
          for (var hit in jsonResponse['hits']) {
            result.add(hit['webformatURL']);
          }

          return result;
        } else {
          print("searchImages error ${response.statusCode}");
        }
      }
    }
    return [];
  }
}

class _ResultSearchCache {
  final _cache = <String, List<String>>{};

  List<String> get(String term) => _cache[term.toLowerCase()];

  void set(String term, List<String> result) => _cache[term.toLowerCase()] = result;

  bool contains(String term) => _cache.containsKey(term.toLowerCase());
  void remove(String term) => _cache.remove(term.toLowerCase());
}
