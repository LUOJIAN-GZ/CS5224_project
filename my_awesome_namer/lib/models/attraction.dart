import 'twitter_url.dart';

class Attraction {
  Attraction(this.name);

  // Attraction.blank()
  //     : name = '',
  //       address = '',
  //       latitude = 0,
  //       longtitude = 0,
  //       rating = 0,
  //       imagePath = '',
  //       metaDescr = '',
  //       openingHours = '',
  //       influenceScore = 0,
  //       twitterURL = TwitterURL.blank();

  Attraction.blank()
      : name = 'Chinatown Heritage Centre, Singapore',
        address = '48 Pagoda Street',
        latitude = 1.28351,
        longtitude = 103.84435,
        rating = 4.2,
        imagePath =
            'https://www.visitsingapore.com/content/dam/desktop/global/see-do-singapore/culture-heritage/chinatown-heritage-centre-carousel01-rect.jpg',
        metaDescr =
            'At the Chinatown Heritage Centre, experience how Singaporeinatown Heritage Centre.',
        openingHours =
            'Daily, 9am atown Heritage Centre, experience how Singaporeinatown Heritage Centre.',
        influenceScore = 0,
        twitterURL = TwitterURL.blank();

  Attraction.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        latitude = json['latitude'],
        longtitude = json['longtitude'],
        rating = json['rating'],
        imagePath = json['imagePath'],
        metaDescr = json['metaDescr'],
        openingHours = json['openingHours'],
        influenceScore = json['influenceScore'],
        twitterURL = TwitterURL.fromJson(json['twitterURL']);

  String name;
  late String address;
  late double latitude;
  late double longtitude;
  late double rating; //Google ratings
  late String imagePath;
  late String metaDescr;
  late String openingHours;
  late double influenceScore;
  late TwitterURL twitterURL;
}
