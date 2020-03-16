import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Set<Marker> markers =  <Marker>{ Marker(markerId: MarkerId("Marker"), infoWindow: InfoWindow(title: "LiterBoard"),position: LatLng(35.9549534,-83.9360237)) };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BEAT THE LINE"),
        leading: Padding(padding: EdgeInsets.all(10), child: Image(image: AssetImage("assets/LogoFilled.png"))),
          automaticallyImplyLeading: false, actions: <Widget>[
        PopupMenuButton(
          onSelected: (index) {
            switch (index) {
              case 1:
                FirebaseAuth.instance.signOut().then((value) => Navigator.popAndPushNamed(context, '/LoginPage'));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
              value: 1,
              child: Text('Log Out'),
            ),
          ],
        )
      ]),
      body: FutureBuilder<DocumentSnapshot>(future: getUserData(), builder: (context, snapshot) {
        if (snapshot.hasData) return GoogleMap(
          markers: markers,
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(target: LatLng(snapshot.data.data['location'].latitude, snapshot.data.data['location'].longitude), zoom: 15),
        );
        else return Center(child: CircularProgressIndicator());
      },)
    );
  }
}

Future<DocumentSnapshot> getUserData() async {
  var user = await FirebaseAuth.instance.currentUser();
  return Firestore.instance.collection('users').document(user.uid).get();
}
