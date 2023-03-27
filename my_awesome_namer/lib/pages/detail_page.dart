import 'package:flutter/material.dart';
import 'package:sgfavour/services/api_client.dart';
import '../models/attraction.dart';
import '../models/twitter_url.dart';
import 'browsing_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(this.id);
  final int id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Attraction? attraction;
  var isLoaded = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    attraction = await ApiService.getAttractionById(widget.id);
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
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {},
                        style: BrowsingPageStyles.buttonLocation,
                        child: const Text("View On Map"),
                      ),
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
          Text(
            attraction.address,
            style: DetailPageStyles.content,
          ),
          SizedBox(height: 15),
          Text(
            "Operating Hours:",
            style: DetailPageStyles.subtitle,
          ),
          Text(
            attraction.openingHours,
            style: DetailPageStyles.content,
          ),
          SizedBox(height: 15),
          Text(
            "Google Rating:",
            style: DetailPageStyles.subtitle,
          ),
          Text(
            attraction.rating.toString(),
            style: DetailPageStyles.content,
          ),
          const SizedBox(height: 40),
          Text(
            "Posts on Twitter: ",
            style: DetailPageStyles.subtitle,
          ),
          attraction.twitterURL != null ? _twitterPostList() : Container(),
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
