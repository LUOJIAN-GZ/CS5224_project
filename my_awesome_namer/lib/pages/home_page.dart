import 'dart:async';
import 'package:flutter/material.dart';
import 'browsing_page.dart';
import 'landing_page.dart';
import 'map_page.dart';
import 'searchpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Widget buildBody;

  @override
  void initState() {
    // buildBody = SearchPage();
    super.initState();
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
          child: nav_bar(),
        ),
      ),
      body: SearchPage(),
    );
  }

  Widget nav_bar() {
    return Row(
      children: <Widget>[
        InkWell(
            onTap: () {
              setState(() {
                buildBody = SearchPage();
              });
            },
            child: const SizedBox(
              child: Text("SGFavour", style: HomePageStyles.logo),
            )),
        const Spacer(),
        NavBarItem(
            title: "Tourism Attractions",
            press: () {
              setState(() {
                buildBody = BrowsingPage();
              });
            }),
        NavBarItem(
            title: "Maps",
            press: () {
              setState(() {
                buildBody = MapPage();
              });
            }),
      ],
    );
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback press;
  const NavBarItem({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Text(title, style: HomePageStyles.tab),
      ),
    );
  }
}

class HomePageStyles {
  static const logo = TextStyle(
    fontSize: 30,
    letterSpacing: 3,
    color: Colors.white,
    fontWeight: FontWeight.w900,
  );

  static const tab = TextStyle(
    fontSize: 18,
    letterSpacing: 1,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}
