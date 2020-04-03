import 'package:BTL/detail.dart';
import 'package:BTL/login.dart';
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
      drawer: Theme(data: ThemeData(canvasColor: Colors.grey.shade900), child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(children: <Widget>[
                CircleAvatar(backgroundImage: Image.asset('assets/DefaultAvatar.jpg').image),
                Padding(padding: EdgeInsets.all(5)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text(localUser.name, style: TextStyle(fontSize: 18, color: Colors.white)),
                  Row(children: List.generate(5, (rating) => Icon(rating < localUser.rating ? Icons.star : Icons.star_border, size: 18, color: Colors.white)))
                ])
              ]),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Deals', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Notifications', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Your Bars', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            Image.asset("assets/LogoOutline.png", color: Colors.grey.shade800),
            ListTile(
              title: Text('About', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Legal', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushNamed(context, '/LegalPage');
              },
            ),
          ],
        ),
      )),
        appBar: AppBar(
            title: Text("BEAT THE LINE", style: TextStyle(color: Colors.white)),
            leading: Padding(padding: EdgeInsets.all(13), child: Image(image: AssetImage("assets/LogoOutline.png"), color: Colors.white)),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Builder(builder: (context) => IconButton(icon: Icon(Icons.dehaze, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer()))
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
                          itemBuilder: (context, index) => FlatButton(
                            color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))),
                              child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(children: <Widget>[
                                    Row(children: <Widget>[
                                      Expanded(child: Row(children: <Widget>[
                                        Flexible(child: Text("${snapshot.data[index].name}   ", style: TextStyle(fontSize: 21, color: Theme.of(context).primaryColor), overflow: TextOverflow.ellipsis)),
                                        Padding(padding: EdgeInsets.all(3)),
                                        FutureBuilder<double>(future: geoLocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, snapshot.data[index].geometry.location.lat, snapshot.data[index].geometry.location.lng),
                                            builder: (context, snapshot) => snapshot.hasData?
                                                //Todo: Use Distance Matrix Maps API
                                            Text(" ${(snapshot.data/1609.344).toStringAsFixed(2)}mi", style: TextStyle(fontSize: 14, color: Colors.grey)) : Container())
                                        ])),
                                      Padding(padding: EdgeInsets.all(5)),
                                      snapshot.data[index].rating != null ? Row(children: List.generate(5, (rating) => Icon(rating < snapshot.data[index].rating ? Icons.star : Icons.star_border, size: 18))) : Container(),
                                    ]),
                                  ])))))
                ]);
              } else return Column(children: <Widget>[
                Expanded(child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(target: localUser.location, zoom: 16),
                )),
                Expanded(child: Container(child: Center(child: CircularProgressIndicator())))
              ]);
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
