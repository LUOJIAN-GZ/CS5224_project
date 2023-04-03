import 'dart:math';

import 'package:flutter/material.dart';
import 'makehttprequest.dart';
import '../models/attraction.dart';
import '../widget/attraction_list.dart';
import 'package:sgfavour/pages/detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var issearch = true;
  var testdata = "";
  final TextEditingController searchController = TextEditingController();

  List<Attraction>? searchresult;
  List<Attraction>? hotResult;
  @override
  void initState() {
    super.initState();
    callHTTPHOTSPOT();
    // ignore: undefined_prefixed_name
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var random_x = Random();
    var random_y = Random();

    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 80.0,
      //   title: TextButton(
      //       onPressed: () {},
      //       child: Text(
      //         'SGFavour',
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      //       )),
      //   actions: [
      //     TextButton(
      //         onPressed: () {},
      //         child: Text(
      //           'Live Trends',
      //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      //         )),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(0, 0, 80, 0),
      //       child: TextButton(
      //           onPressed: () {},
      //           child: Text(
      //             'Category',
      //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      //           )),
      //     ),
      //   ],
      //   backgroundColor: Color.fromARGB(255, 58, 63, 88),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Image.asset('assets/img/background1.png'),
              Positioned.fill(
                  child: ColoredBox(color: Color.fromARGB(90, 255, 255, 255))),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Explore the trending events in Singapore...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 55,
                        color: Color.fromARGB(255, 58, 63, 88)),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(200.0, 120, 200.0, 0),
              child: TextField(
                onSubmitted: (_) => onSubmitdata(),
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  labelText: 'Search things here',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: onSubmitdata,
                  ),
                ),
              ),
            ),
            if (issearch) buildHotspotWidget(),
            if (!issearch)
              Container(
                  width: 1000,
                  child: AttractionList(attractionList: searchresult)),
          ],
        ),
      ),
    );
  }

  Widget buildHotspotWidget() {
    final List positionsLeft = [200, 500, 200, 800, 800];
    final List positionsRight = [50, 100, 150, 150, 50];
    final hotResultlocal = hotResult;
    final List<Widget> hotResultwiget = [];
    if (hotResultlocal != null) {
      for (int index = 0; index < 5; index++) {
        hotResultwiget.add(buildHotList(
            positionsLeft[index],
            positionsRight[index],
            hotResultlocal[index].id,
            hotResultlocal[index].name));
      }
    }
    // final list positionsRight
    return SizedBox(
      width: 1400.0,
      height: 200.0,
      child: Stack(children: hotResultwiget),
    );
  }

  Widget buildSearchResult() {
    return Container(
      color: Colors.blueGrey,
      width: 500,
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Content"),
              ],
            ),
          ),
          Image.network(
            "https://ichef.bbci.co.uk/news/976/cpsprodpb/15951/production/_117310488_16.jpg.webp",
            height: 200,
            width: 200,
          ),
        ],
      ),
    );
  }

  void onSubmitdata() async {
    print(searchController.text);
    searchresult = await makeRequest(searchController.text);
    setState(() {
      issearch = false;
    });
  }

  Widget buildHotList(double left, double bottom, int id, String name) {
    return Positioned(
        left: left,
        bottom: bottom,
        child: TextButton.icon(
          icon: Icon(
            Icons.tour_outlined,
            color: Color.fromARGB(255, 58, 63, 88),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(id),
            ),
          ),
          label: Text(name, style: BrowsingPageStyles.filterLabel),
        ));
  }

  callHTTPHOTSPOT() async {
    var result = await makeRequestHottwitter();
    setState(() {
      hotResult = result;
    });
  }
}
