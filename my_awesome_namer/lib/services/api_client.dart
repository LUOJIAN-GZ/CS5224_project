import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/attraction.dart';

class ApiService {
  static String cookie = '';
  static String token = '';
  static const String baseUrl =
      'https://4q3yf6foqc.execute-api.us-east-1.amazonaws.com/cs5224_api/attractions';

  static Future<List<Attraction>> getAttractionList(double latitude,
      double longitude, int flagLocation, int distance, int orderBy) async {
    var client = http.Client();
    // var apicallUrl =
    // '?latitude=$latitude&longitude=$longitude&flag_location=$flagLocation&distance=$distance&orderby=$orderBy';

    // var uri = Uri.https('example.org', '/path', {'q': 'dart'});
    // print(uri); // https://example.org/path?q=dart

    // var uri = Uri.https('4q3yf6foqc.execute-api.us-east-1.amazonaws.com',
    //     'cs5224_api/attractions', {
    //   'latitude': latitude,
    //   'longitude': longitude,
    //   'flag_location': flagLocation,
    //   'orderby': orderBy
    // });

    var uri = Uri.parse('$baseUrl'
        '?latitude=$latitude&longitude=$longitude&flag_location=$flagLocation&distance=$distance&orderby=$orderBy');
    print(uri);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)['body'];
      print(json);
      print(attractionFromJson(json));
      return attractionFromJson(json);
    } else {
      throw Exception();
    }
  }
}
