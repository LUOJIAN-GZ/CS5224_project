import 'twitter_url.dart';

List<Attraction> attractionFromJson(List<dynamic> str) =>
    List<Attraction>.from(str.map((x) => Attraction.fromJson(x)));

class Attraction {
  Attraction(
      {required this.id,
      required this.name,
      required this.imagePath,
      required this.metaDescr,
      this.address,
      this.latitude,
      this.longitude,
      this.rating,
      this.openingHours,
      this.influenceScore,
      this.twitterURL});

  Attraction.blank()
      : id = 0,
        name = '',
        address = '',
        latitude = 0,
        longitude = 0,
        rating = 0,
        imagePath = '',
        metaDescr = '',
        openingHours = '',
        influenceScore = 0,
        twitterURL = null;

  // Attraction.blank()
  //     : id = 1,
  //       name = 'Chinatown Heritage Centre, Singapore',
  //       address = '48 Pagoda Street',
  //       latitude = 1.28351,
  //       longitude = 103.84435,
  //       rating = 4.2,
  //       imagePath =
  //           'https://www.visitsingapore.com/content/dam/desktop/global/see-do-singapore/culture-heritage/chinatown-heritage-centre-carousel01-rect.jpg',
  //       metaDescr =
  //           'At the Chinatown Heritage Centre, experience how Singaporeinatown Heritage Centre.',
  //       openingHours =
  //           'Daily, 9am atown Heritage Centre, experience how Singaporeinatown Heritage Centre.',
  //       // influenceScore = 0,
  //       twitterURL = [];

  Attraction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imagePath = "https://${json['image_path']}",
        metaDescr = json['meta_descr'],
        address = json.containsKey("address") ? json['address'] : null,
        // json['address'] in json.keys,
        latitude = json.containsKey("latitude") ? json['latitude'] : null,
        // json['latitude'],
        longitude = json.containsKey("longitude") ? json['longitude'] : null,
        // json['longitude'],
        rating = json.containsKey("rating") ? json['rating'] : null,
        openingHours =
            json.containsKey("opening_hours") ? json['opening_hours'] : null,
        influenceScore = json.containsKey("influence_score")
            ? json['influence_score']
            : null,
        twitterURL = json.containsKey("twitter_posts")
            ? twitterFromJson(json['twitter_posts'])
            : null;

  final int id;
  final String name;
  final String imagePath;
  final String metaDescr;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? rating; //Google ratings
  final String? openingHours;
  final double? influenceScore;
  final List<TwitterURL>? twitterURL;
}
