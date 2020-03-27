import 'package:BTL/detail.dart';
import 'package:BTL/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        body: FutureBuilder<List<PlaceData>>(
            future: getMapData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Set<Marker> markers = Set();
                snapshot.data.forEach((place) => markers.add(Marker(markerId: MarkerId(place.name), infoWindow: InfoWindow(title: place.name), position: LatLng(place.location.latitude, place.location.longitude))));
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
                                      Text(snapshot.data[index].name, style: TextStyle(fontSize: 21, color: Theme.of(context).primaryColor)),
                                      //Padding(padding: EdgeInsets.all(3)),
                                      Text(" ${snapshot.data[index].distance.toStringAsFixed(1)}mi", style: TextStyle(fontSize: 14, color: Colors.grey)),
                                      Spacer(),
                                      Row(children: List.generate(5, (rating) => Icon(rating < snapshot.data[index].rating ? Icons.star : Icons.star_border, size: 18))),
                                    ]),
                                    Text(snapshot.data[index].description),
                                  ])))))
                ]);
              } else
                return Center(child: CircularProgressIndicator());
            }));
  }
}

Future<List<PlaceData>> getMapData() async {
  QuerySnapshot query = await Firestore.instance.collection('places').getDocuments();

  List<PlaceData> places = List();

  for (DocumentSnapshot doc in query.documents) {
    double dist = await geolocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, doc.data['location'].latitude, doc.data['location'].longitude).catchError((err) => print("ERROR: $err"));
    places.add(PlaceData(name: doc.data['name'], location: LatLng(doc.data['location'].latitude, doc.data['location'].longitude), rating: doc.data['rating'], description: doc.data['description'], distance: dist / 1609.344));
  }
  return places;
}

class PlaceData {
  PlaceData({this.name, this.location, this.rating, this.distance, this.description});

  LatLng location;
  int rating;
  double distance;
  String name, description;
}
