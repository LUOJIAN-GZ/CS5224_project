import 'dart:math';

import 'package:flutter/material.dart';
import 'makehttprequest.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    makeRequest();
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
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 800.0,
              height: 200.0,
              child: Stack(children: [
                Positioned(
                  left: 50,
                  bottom: 150,
                  child: Text('#HaiDiLao'),
                ),
                Positioned(
                  left: 200,
                  bottom: 50,
                  child: Text('#HaiDiLao'),
                ),
                Positioned(
                  left: 550,
                  bottom: 50,
                  child: Text('#HaiDiLao'),
                ),
                Positioned(
                  left: 300,
                  bottom: 150,
                  child: Text('#HaiDiLao'),
                ),
                Positioned(
                  left: 700,
                  bottom: 50,
                  child: Text('#HaiDiLao'),
                ),
                Positioned(
                  left: 600,
                  bottom: 150,
                  child: Text('#HaiDiLao'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
