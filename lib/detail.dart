import 'package:BTL/login.dart';
import 'package:BTL/main.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';

class DetailPage extends StatefulWidget {
  final PlaceDetails data;
  DetailPage(this.data, {Key key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        body: Column(children: <Widget>[
          Stack(alignment: Alignment.bottomLeft ,children: <Widget>[
            Image.asset("assets/Bar.jpg"),
            Padding(padding: EdgeInsets.all(15), child: Row(children: <Widget>[
              Text(widget.data.name, style: TextStyle(fontSize: 58, color: Colors.white)),
              FutureBuilder<double>(future: geoLocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, widget.data.geometry.location.lat, widget.data.geometry.location.lng),
                  builder: (context, snapshot) => snapshot.hasData?
                  Text(" ${(snapshot.data/1609.344).toStringAsFixed(1)}mi", style: TextStyle(fontSize: 24, color: Colors.grey)) : Container())
            ]))
          ])
        ]));
  }
}
