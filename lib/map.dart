import 'package:BTL/detail.dart';
import 'package:BTL/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import 'main.dart';

class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("BEAT THE LINE", style: TextStyle(color: Colors.white)),
            leading: Padding(padding: EdgeInsets.all(13), child: Image(image: AssetImage("assets/LogoOutline.png"), color: Colors.white)),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (index) {
                  switch (index) {
                    case 1:
                      FirebaseAuth.instance.signOut().then((value) => Navigator.popAndPushNamed(context, '/LoginPage'));
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/NewPlacePage');
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 1,
                    child: Text('Log Out'),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text('Add Place'),
                  ),
                ],
              )
            ]),
        body: FutureBuilder<List<PlaceDetails>>(
            future: getMapData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Set<Marker> markers = Set();
                snapshot.data.forEach((place) => markers.add(Marker(markerId: MarkerId(place.name), infoWindow: InfoWindow(title: place.name), position: LatLng(place.geometry.location.lat, place.geometry.location.lng))));
                return Column(children: <Widget>[
                  Expanded(
                      child: GoogleMap(
                        markers: markers,
                        mapType: MapType.hybrid,
                        initialCameraPosition: CameraPosition(target: localUser.location, zoom: 16),
                      )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) => Container(
                              color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
                              padding: EdgeInsets.all(20),
                              child: GestureDetector(
                                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))),
                                  child: Column(children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(child: Row(children: <Widget>[
                                        Expanded(child: Text(snapshot.data[index].name, style: TextStyle(fontSize: 21, color: Theme.of(context).primaryColor), overflow: TextOverflow.ellipsis)),
                                        Padding(padding: EdgeInsets.all(3)),
                                        FutureBuilder<double>(future: geoLocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, snapshot.data[index].geometry.location.lat, snapshot.data[index].geometry.location.lng),
                                            builder: (context, snapshot) => snapshot.hasData?
                                            Text(" ${(snapshot.data/1609.344).toStringAsFixed(2)}mi", style: TextStyle(fontSize: 14, color: Colors.grey)) : Container())
                                        ])),
                                      Padding(padding: EdgeInsets.all(15)),
                                      Row(children: List.generate(5, (rating) => Icon(rating < snapshot.data[index].rating ? Icons.star : Icons.star_border, size: 18))),
                                    ]),
                                  ])))))
                ]);
              } else
                return Center(child: CircularProgressIndicator());
            }));
  }
}

Future<List<PlaceDetails>> getMapData() async {
  final GoogleMapsPlaces maps = GoogleMapsPlaces(apiKey: 'AIzaSyBw9I3gA17vDFQS1lZkuLG8tH79YdIz21k');
  final result = await maps.searchNearbyWithRankBy(Location(localUser.location.latitude, localUser.location.longitude), 'distance', type: 'bar');
  List<PlaceDetails> detailsList = List();
  await Future.forEach<PlacesSearchResult>(result.results, (place) async {
    PlacesDetailsResponse res = await maps.getDetailsByPlaceId(place.placeId);
    if (res.isOkay) detailsList.add(res.result);
  });
  return detailsList;
}

class PlaceData {
  PlaceData({this.name, this.location, this.rating, this.distance, this.description});

  LatLng location;
  int rating;
  double distance;
  String name, description;
}
