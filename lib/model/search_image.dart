import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SearchImage {
  final urlAPI = "https://pixabay.com/api/?";
  final _key = "";
  static final SearchImage _singleton = SearchImage._internal();

  SearchImage._internal();

  factory SearchImage() {
    return _singleton;
  }

  Future<List<String>> searchImages(String query) async {
    if(query.isNotEmpty) {
      final _query = query.replaceAll(' ', '+');
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
    return [];
  }
}
