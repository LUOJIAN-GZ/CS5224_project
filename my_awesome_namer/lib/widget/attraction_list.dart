import 'package:flutter/material.dart';
import '../models/attraction.dart';
import 'package:sgfavour/pages/detail_page.dart';

class AttractionList extends StatelessWidget {
  const AttractionList({super.key, this.attractionList});
  final List<Attraction>? attractionList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attractionList?.length,
      itemBuilder: (context, index) {
        return _attractionCard(context, attractionList![index], index);
      },
    );
  }

  Widget _attractionCard(
      BuildContext context, Attraction attraction, int index) {
    // print(attraction.imagePath);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.6),
              offset: Offset(10, 10),
              blurRadius: 10)
        ],
      ),
      child: Row(
        children: [
          Container(
            color: Color.fromARGB(255, 231, 142, 130),
            width: 80,
            alignment: Alignment.center,
            child: Text(
              (index + 1).toString(),
              style: BrowsingPageStyles.index,
            ),
          ),
          Container(
            width: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitHeight,
              alignment: FractionalOffset.topCenter,
              image: NetworkImage(attraction.imagePath),
            )),
          ),
          // Image.network("https://${attraction.imagePath}"),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              color: Color.fromARGB(255, 248, 226, 217),
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    child: Text(attraction.name,
                        style: BrowsingPageStyles.cardTitle),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(attraction.id),
                      ),
                    ),
                    // onTap: () {
                    //   print('tap attraction id ${attraction.id}');
                    //   print(buildBody);
                    //   setState(() {
                    //     buildBody = DetailPage(attraction.id);
                    //   });
                    //   print(buildBody);
                    // },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(attraction.metaDescr,
                      style: BrowsingPageStyles.cardDesc),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/img/google.png',
                        height: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Rating:",
                        style: BrowsingPageStyles.cardDesc,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        attraction.rating.toString(),
                        style: BrowsingPageStyles.cardDesc,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrowsingPageStyles {
  static const heading = TextStyle(
      fontSize: 30,
      color: Color.fromARGB(255, 58, 63, 88),
      fontWeight: FontWeight.w900,
      shadows: <Shadow>[
        Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 2.0,
            color: Color.fromARGB(150, 58, 63, 88)),
      ]);

  static var buttonLocation = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 231, 142, 130),
    foregroundColor: Color.fromARGB(255, 58, 63, 88),
    textStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.3,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
    minimumSize: Size(250, 60),
  );

  static var buttonSearch = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 249, 172, 103),
    foregroundColor: Color.fromARGB(255, 58, 63, 88),
    textStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w900,
      letterSpacing: 0.3,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
    minimumSize: Size(250, 60),
  );

  static const filterLabel = TextStyle(
    fontSize: 15,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w600,
  );

  static const dropdown = TextStyle(
    fontSize: 15,
    letterSpacing: 0.5,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w600,
  );

  static const index = TextStyle(
    fontSize: 30,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w900,
  );

  static const cardTitle = TextStyle(
    fontSize: 20,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w800,
    decoration: TextDecoration.underline,
  );

  static const cardDesc = TextStyle(
    fontSize: 14,
    height: 1.2,
    color: Color.fromARGB(255, 58, 63, 88),
    fontWeight: FontWeight.w600,
  );
}
