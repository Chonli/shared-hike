import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SearchImage {
  final urlAPI = "https://pixabay.com/api/?";
  final _key = "<add key here>";
  static final SearchImage _singleton = SearchImage._internal();

  SearchImage._internal();

  factory SearchImage() {
    return _singleton;
  }

  Future<List<String>> searchImages(String query) async {
    //final _query = query.replaceAll(' ', '+');
    var client = new http.Client();    
    var response = await client.get(urlAPI + "key=$_key&q=$query&image_type=photo");

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      return [];
    } else {
      print("searchImages error ${response.statusCode}");
      return [];
    }
  }
}
