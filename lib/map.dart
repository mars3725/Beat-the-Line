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
        appBar: AppBar(title: Text("BEAT THE LINE", style: TextStyle(color: Colors.white)), leading: Padding(padding: EdgeInsets.all(13), child: Image(image: AssetImage("assets/LogoOutline.png"), color: Colors.white)), automaticallyImplyLeading: false, actions: <Widget>[
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
        body: FutureBuilder<MapData>(
            future: getMapData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Set<Marker> markers = Set();
                snapshot.data.places.forEach((place) => markers.add(Marker(
                    markerId: MarkerId(place.data['name']),
                    infoWindow: InfoWindow(title: place.data['name']),
                    position: LatLng(place.data['location'].latitude, place.data['location'].longitude))
                ));
                return Column(children: <Widget>[
                  Expanded(child: GoogleMap(
                    markers: markers,
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(target: snapshot.data.userLocation, zoom: 16),
                  )),
                  Expanded(child: ListView.builder(itemCount: snapshot.data.places.length, itemBuilder: (context, index) => Container(color: index% 2 == 0? Colors.grey.shade300 : Colors.white, padding: EdgeInsets.all(20), child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Text(snapshot.data.places[index].data['name'], style: TextStyle(fontSize: 21, color: Theme.of(context).primaryColor)),
                      //Padding(padding: EdgeInsets.all(3)),
                      Text(" ${snapshot.data.distances[index].toStringAsFixed(1)}mi", style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Spacer(),
                      Row(children: List.generate(5, (rating) => Icon(rating < snapshot.data.places[index].data['rating'] ? Icons.star : Icons.star_border, size: 18))),
                    ]),
                    Text(snapshot.data.places[index].data['description']),
                  ])))
                  )
                ]);
              } else return Center(child: CircularProgressIndicator());
            }));
  }
}

Future<MapData> getMapData() async {
  DocumentSnapshot user = await Firestore.instance.collection('users').document((await FirebaseAuth.instance.currentUser()).uid).get();
  QuerySnapshot places = await Firestore.instance.collection('places').getDocuments();

  MapData data = MapData();
  data.userLocation = LatLng(user.data['location'].latitude, user.data['location'].longitude);
  data.places = places.documents;
  data.distances = List(3);
  for(int i = 0; i < data.places.length; i++) {
    double dist = await geolocator.distanceBetween(data.userLocation.latitude, data.userLocation.longitude,
        data.places[i].data['location'].latitude, data.places[i].data['location'].longitude).catchError(
            (err) => print("ERROR: $err"));
    data.distances[i] = dist/1609.344;
  } //await Future.forEach(data.places, (place) async => data.distances.add();
  return data;
}

class MapData {
  LatLng userLocation;
  List<double> distances;
  List<DocumentSnapshot> places;
}
