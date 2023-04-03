import 'package:flutter/material.dart';
import 'package:sgfavour/services/api_client.dart';
import '../models/attraction.dart';
import '../models/twitter_url.dart';
import '../widget/attraction_list.dart';
import 'dart:ui' as ui;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

class DetailPage extends StatefulWidget {
  const DetailPage(this.id);
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Attraction? attraction;
  var isLoaded = false;
  var hasTwitter = false;

  // var urls = [
  //   // "https://twitter.com/JackPosobiec/status/1641836207993765890",
  //   // "https://twitter.com/Leonidas_SBC/status/1617604977383333888",
  //   "https://twitter.com/aymanitani/status/1641832727262445568",
  //   "https://twitter.com/cupTWOst/status/1641579532342919169"
  // ];

  var urls = [];

  String returnHTMLcode(List urls) {
    String resultHtml = """<!DOCTYPE html>
<html lang="en">
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script></body>
<body>""";

    for (final url in urls) {
      resultHtml += """
      <blockquote class="twitter-tweet">
      <a href="$url">
      </a>
      </blockquote>""";
    }
    resultHtml += """</body>
</html>""";
    return resultHtml;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    attraction = await ApiService.getAttractionById(widget.id);
    // print(hasTwitter);
    if (attraction!.twitterURL!.isNotEmpty) {
      for (TwitterURL post in attraction!.twitterURL!) {
        urls.add(post.url);
      }
      setState(() {
        hasTwitter = true;
      });
      // print(hasTwitter);
    } else {
      print("no twitter post");
    }

    // // ignore: undefined_prefixed_name
    // ui.platformViewRegistry.registerViewFactory('twitter-view', (viewId) {
    //   print(viewId);
    //   print(urls);
    //   final iFrameElement = IFrameElement()
    //     ..width = '500'
    //     ..height = '1300'
    //     // ..src = "assets/asd.html"
    //     ..srcdoc = returnHTMLcode(urls)
    //     ..style.border = 'none';
    //   iFrameElement
    //       .appendHtml("""text""", treeSanitizer: NodeTreeSanitizer.trusted);
    //   return iFrameElement;
    // });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(returnHTMLcode(urls), (viewId) {
      // print(viewId);
      // print(urls);
      final iFrameElement = IFrameElement()
        ..width = '500'
        ..height = '1300'
        // ..src = "assets/asd.html"
        ..srcdoc = returnHTMLcode(urls)
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      iFrameElement
          .appendHtml("""text""", treeSanitizer: NodeTreeSanitizer.trusted);
      return iFrameElement;
    });

    if (attraction != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 241, 215),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          color: const Color.fromARGB(255, 58, 63, 88),
          padding: const EdgeInsets.all(20),
          child: returnLastPageBar(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
          child: Visibility(
            visible: isLoaded,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 300,
                        width: 400,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  offset: Offset(10, 10),
                                  blurRadius: 10)
                            ],
                            image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              alignment: FractionalOffset.topCenter,
                              image: NetworkImage(attraction != null
                                  ? attraction!.imagePath
                                  : ""),
                            )),
                      ),
                      // const SizedBox(height: 60),
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   style: BrowsingPageStyles.buttonLocation,
                      //   child: const Text("View On Map"),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: attraction != null
                      ? detailInfo(attraction!)
                      : Container(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget returnLastPageBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_left_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
        ),
        Text(
          "Attraction Details",
          style: DetailPageStyles.heading,
        ),
        Spacer(),
      ],
    );
  }

  Widget detailInfo(Attraction attraction) {
    final addressLocal = attraction.address;
    final openingHoursLocal = attraction.openingHours;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attraction.name,
            style: DetailPageStyles.attractionName,
          ),
          SizedBox(height: 30),
          Text(
            attraction.metaDescr,
            style: DetailPageStyles.content,
          ),
          SizedBox(height: 15),
          Text(
            "Address:",
            style: DetailPageStyles.subtitle,
          ),
          if (addressLocal != null)
            Text(
              addressLocal,
              style: DetailPageStyles.content,
            ),
          SizedBox(height: 15),
          Text(
            "Operating Hours:",
            style: DetailPageStyles.subtitle,
          ),
          if (openingHoursLocal != null)
            Text(
              openingHoursLocal,
              style: DetailPageStyles.content,
            ),
          SizedBox(height: 25),
          Row(
            children: [
              Image.asset(
                'assets/img/google.png',
                height: 35,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Rating:",
                style: DetailPageStyles.subtitle,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                attraction.rating.toString(),
                style: DetailPageStyles.content,
              ),
            ],
          ),
          const SizedBox(height: 40),
          _twitterPost(),
          // Row(
          //   children: [
          //     Text(
          //       "Posts on",
          //       style: DetailPageStyles.subtitle,
          //     ),
          //     SizedBox(
          //       width: 5,
          //     ),
          //     Image.asset(
          //       'assets/img/twitter.png',
          //       height: 40,
          //     ),
          //   ],
          // ),
          // // attraction.twitterURL != null ? _twitterPostList() : Container(),
          // SizedBox(
          //     width: 500,
          //     height: 1400,
          //     child: HtmlElementView(viewType: 'twitter-view')),
        ],
      ),
    );
  }

  Widget _twitterPost() {
    return Visibility(
      visible: hasTwitter,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Posts on",
                style: DetailPageStyles.subtitle,
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                'assets/img/twitter.png',
                height: 40,
              ),
            ],
          ),
          // attraction.twitterURL != null ? _twitterPostList() : Container(),
          Visibility(
            visible: hasTwitter,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: SizedBox(
              width: 500,
              height: 1400,
              // child: HtmlElementView(viewType: 'twitter-view'),
              child: HtmlElementView(viewType: returnHTMLcode(urls)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twitterPostList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attraction!.twitterURL?.length,
      itemBuilder: (context, index) {
        return _twitterCard(attraction!.twitterURL![index]);
      },
    );
  }

  Widget _twitterCard(TwitterURL twitterPost) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 248, 226, 217),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              offset: Offset(10, 10),
              blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              twitterPost.text,
              style: DetailPageStyles.twitterText,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: Text(
                ">>> View original post on Twitter >>>",
                style: DetailPageStyles.twitterURL,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailPageStyles {
  static const heading = TextStyle(
    fontSize: 18,
    letterSpacing: 1,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
  static const attractionName = TextStyle(
    fontSize: 24,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w900,
  );
  static const content = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w500,
  );
  static const subtitle = TextStyle(
    fontSize: 18,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w900,
  );
  static const twitterText = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w500,
  );
  static const twitterURL = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );
}
