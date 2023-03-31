import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sgfavour/pages/detail_page.dart';
import 'package:sgfavour/services/api_client.dart';
import '../models/attraction.dart';

class BrowsingPage extends StatefulWidget {
  const BrowsingPage({super.key});

  @override
  State<BrowsingPage> createState() => _BrowsingPageState();
}

class _BrowsingPageState extends State<BrowsingPage> {
  List<Attraction>? attractionList;
  var isLoaded = false;
  // List<Attraction> attractionList = [
  //   Attraction.blank(),
  //   Attraction.blank(),
  //   Attraction.blank(),
  //   Attraction.blank(),
  //   Attraction.blank(),
  // ];

  late double lat;
  late double long;
  String locationmessage = "Get current location";
  late GoogleMapController googleMapController;
  static const CameraPosition initialPosition =
      CameraPosition(target: LatLng(1.3521, 103.8198), zoom: 11.0);
  Set<Marker> markers = {};

  // var distanceItems = ['1km', '3km', '5km', '10km'];
  // String distanceDropdownValue = '3km';

  var distanceItems = [1, 3, 5, 10];
  int distanceDropdownValue = 3;

  var orderByItems = ['GoogleMaps Review', 'Twitter Trends'];
  String orderByDropdownValue = 'GoogleMaps Review';

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service is disabled.");
    } else {
      return await Geolocator.getCurrentPosition();
    }
  }

  getData() async {
    var orderByIndex = 1;
    if (orderByDropdownValue == 'Twitter Trends') {
      orderByIndex = 2;
    }

    if (isLoaded == false) {
      lat = 1.3057701;
      long = 103.7731644;
      distanceDropdownValue = 10;
    }

    attractionList = await ApiService.getAttractionList(
        lat, long, 1, distanceDropdownValue, orderByIndex);
    if (attractionList != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Explore the trending tourism attractions around you.",
                style: BrowsingPageStyles.heading),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                      width: 300,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 58, 63, 88),
                            offset: Offset(0, 4),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: GoogleMap(
                          initialCameraPosition: initialPosition,
                          markers: markers,
                          mapType: MapType.normal,
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                          }),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        Position position = await _getCurrentLocation();
                        lat = position.latitude;
                        long = position.longitude;

                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(lat, long), zoom: 14.0)));
                        markers.clear();
                        markers.add(Marker(
                            markerId: const MarkerId('currentLocation'),
                            position:
                                LatLng(position.latitude, position.longitude)));
                        setState(() {});
                      },
                      style: BrowsingPageStyles.buttonLocation,
                      child: const Text("Get current location"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        getData();
                        setState(() {});
                      },
                      style: BrowsingPageStyles.buttonSearch,
                      child: const Text("Search"),
                    ),
                  ],
                ),
                Container(
                  width: 0.6 * MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _filterRow(),
                      Visibility(
                        visible: isLoaded,
                        replacement: Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: _attractionList(),
                      ), //Listview builder
                    ],
                  ),
                ),
              ],
            ),

            // Text(locationmessage, textAlign: TextAlign.center),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //     onPressed: () {
            //       _getCurrentLocation().then((value) {
            //         lat = '${value.latitude}';
            //         long = '${value.longitude}';
            //         setState(() {
            //           locationmessage = 'Latitude: $lat, Longitude: $long';
            //         });
            //       });
            //     },
            //     child: const Text("Current Location")),
            // const SizedBox(height: 20),
            // Container(
            //   height: 500,
            //   width: 800,
            //   child: GoogleMap(
            //       initialCameraPosition: initialPosition,
            //       markers: markers,
            //       mapType: MapType.normal,
            //       onMapCreated: (GoogleMapController controller) {
            //         googleMapController = controller;
            //       }),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _filterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Distance', style: BrowsingPageStyles.filterLabel),
        const SizedBox(width: 20),
        DropdownButton(
          icon: const Icon(Icons.arrow_drop_down_sharp),
          value: distanceDropdownValue,
          style: BrowsingPageStyles.dropdown,
          items: distanceItems.map((int items) {
            return DropdownMenuItem(
              value: items,
              child: Text('${items}km'),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              distanceDropdownValue = newValue!;
              print(distanceDropdownValue);
            });
          },
        ),
        const SizedBox(width: 40),
        Text('Order by', style: BrowsingPageStyles.filterLabel),
        const SizedBox(width: 20),
        DropdownButton(
          icon: const Icon(Icons.arrow_drop_down_sharp),
          value: orderByDropdownValue,
          style: BrowsingPageStyles.dropdown,
          items: orderByItems.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              orderByDropdownValue = newValue!;
              print(orderByDropdownValue);
            });
          },
        ),
      ],
    );
  }

  Widget _attractionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attractionList?.length,
      itemBuilder: (context, index) {
        return _attractionCard(attractionList![index], index);
      },
    );
  }

  Widget _attractionCard(Attraction attraction, int index) {
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
