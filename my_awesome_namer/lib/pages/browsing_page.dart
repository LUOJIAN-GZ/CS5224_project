import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/attraction.dart';

class BrowsingPage extends StatefulWidget {
  const BrowsingPage({super.key});

  @override
  State<BrowsingPage> createState() => _BrowsingPageState();
}

class _BrowsingPageState extends State<BrowsingPage> {
  List<Attraction> attractionList = [
    Attraction.blank(),
    Attraction.blank(),
    Attraction.blank(),
    Attraction.blank(),
    Attraction.blank(),
  ];

  late String lat;
  late String long;
  String locationmessage = "Get current location";
  late GoogleMapController googleMapController;
  static const CameraPosition initialPosition =
      CameraPosition(target: LatLng(1.3521, 103.8198), zoom: 11.0);
  Set<Marker> markers = {};

  var distanceItems = ['1km', '3km', '5km', '10km'];
  String distanceDropdownValue = '3km';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Explore the trending tourism attractions around you.",
              style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 58, 63, 88),
                  fontWeight: FontWeight.w600,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                      color: Color.fromARGB(150, 58, 63, 88),
                    ),
                  ]),
            ),
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
                        googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    position.latitude, position.longitude),
                                zoom: 14.0)));
                        markers.clear();
                        markers.add(Marker(
                            markerId: const MarkerId('currentLocation'),
                            position:
                                LatLng(position.latitude, position.longitude)));
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(200, 238, 106, 89),
                        foregroundColor: const Color.fromARGB(200, 58, 63, 88),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      child: const Text("Get current location"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 249, 172, 103),
                        foregroundColor: const Color.fromARGB(255, 58, 63, 88),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
                      _attractionList(), //Listview builder
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
        const Text('Distance'),
        const SizedBox(width: 20),
        DropdownButton(
          value: distanceDropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: distanceItems.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              distanceDropdownValue = newValue!;
            });
          },
        ),
        const SizedBox(width: 40),
        const Text('Order by'),
        const SizedBox(width: 20),
        DropdownButton(
          value: orderByDropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: orderByItems.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              orderByDropdownValue = newValue!;
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
      itemCount: attractionList.length,
      itemBuilder: (context, index) {
        return _attractionCard(
          attractionList[index],
        );
      },
    );
  }

  Widget _attractionCard(Attraction attraction) {
    return Container(
      height: 200,
      child: Column(
        children: [
          Text(
            attraction.name,
          ),
          Text(attraction.address)
        ],
      ),
    );
  }
}
