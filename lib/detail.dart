import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'map.dart';

class DetailPage extends StatefulWidget {
  final PlaceData data;
  DetailPage(this.data, {Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

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
        body: Column(children: <Widget>[
          Stack(alignment: Alignment.bottomLeft ,children: <Widget>[
            Image.asset("assets/Bar.jpg"),
            Padding(padding: EdgeInsets.all(15), child: Column(children: <Widget>[
              Text(widget.data.name, style: TextStyle(fontSize: 60, color: Colors.white)),
              Text(widget.data.description, style: TextStyle(fontSize: 18, color: Colors.white)),
            ]))
          ])
        ]));
  }

  Future<void> getPlaceDetails() {

  }
}
