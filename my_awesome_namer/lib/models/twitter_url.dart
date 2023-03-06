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
