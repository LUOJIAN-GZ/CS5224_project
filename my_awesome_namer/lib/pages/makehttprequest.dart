import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/attraction.dart';

makeRequest(String searchWord) async {
  // var url = Uri.parse('https://www.google.com/');
  // var response = await http.get(url);
  var response;
  List<Attraction>? extract_data;
  try {
    response = await http.get(Uri.parse(
        'https://iu9iodz8n1.execute-api.ap-southeast-1.amazonaws.com/cs5224_apis/attractions/search?keyword=$searchWord'));
  } catch (e) {
    print(e);
  }

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body)['body'];
    // Request was successful, parse the response
    // print(attractionFromJson(json));
    extract_data = attractionFromJson(json);
    return extract_data;
  } else {
    // Request failed, handle the error
    print('Request failed with status: ${response.statusCode}.');
  }
  print("test http request");
}

makeRequestHottwitter() async {
  var response;
  List<Attraction>? extract_data;
  try {
    response = await http.get(Uri.parse(
        'https://iu9iodz8n1.execute-api.ap-southeast-1.amazonaws.com/cs5224_apis/attractions?&flag_location=0&distance=10&orderby=0'));
  } catch (e) {
    print(e);
  }
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body)['body'];
    // Request was successful, parse the response
    // print(attractionFromJson(json));
    extract_data = attractionFromJson(json);
    print(extract_data);
    return extract_data;
  } else {
    // Request failed, handle the error
    print('Request failed with status: ${response.statusCode}.');
  }
  print("test http request");
}
