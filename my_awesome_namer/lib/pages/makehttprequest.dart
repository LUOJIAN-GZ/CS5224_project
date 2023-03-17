import 'package:http/http.dart' as http;

void makeRequest() async {
  // var url = Uri.parse('https://www.google.com/');
  // var response = await http.get(url);
  var response;
  try {
    response = await http.get(Uri.parse(
        'https://4q3yf6foqc.execute-api.us-east-1.amazonaws.com/cs5224_api/attractions?latitude=1.2838785&longitude=103.85899&flag_location=1&distance=10&orderby=1'));
  } catch (e) {
    print(e);
  }

  if (response.statusCode == 200) {
    // Request was successful, parse the response
    print(response.body);
  } else {
    // Request failed, handle the error
    print('Request failed with status: ${response.statusCode}.');
  }
  print("test http request");
}
