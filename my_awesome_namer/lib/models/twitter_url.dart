import 'dart:convert';

List<TwitterURL> twitterFromJson(String str) =>
    List<TwitterURL>.from(json.decode(str).map((x) => TwitterURL.fromJson(x)));

class TwitterURL {
  TwitterURL(this.text, this.url);

  // TwitterURL.blank()
  //     : text = '',
  //       url = '';

  TwitterURL.blank()
      : text = 'asfkjbalkrgblvkzdnlarjg',
        url = 'sadxkgjb;aklxdjfk.sdz';

  TwitterURL.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        url = json['url'];

  String text;
  String url;
}
