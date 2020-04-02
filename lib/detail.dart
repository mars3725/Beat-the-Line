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
            Padding(padding: EdgeInsets.all(25), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              Flexible(child: Text(widget.data.name, style: TextStyle(fontSize: 52, color: Colors.white), softWrap: true, overflow: TextOverflow.ellipsis)),
              FutureBuilder<double>(future: geoLocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, widget.data.geometry.location.lat, widget.data.geometry.location.lng),
                  builder: (context, snapshot) => snapshot.hasData?
                  Align(alignment: Alignment.bottomCenter, child: Text("${(snapshot.data/1609.344).toStringAsFixed(1)}mi", style: TextStyle(fontSize: 24, color: Colors.grey))) : Container())          
            ]))
          ]),
          Padding(padding: EdgeInsets.all(15), child: Row(children: <Widget>[Icon(Icons.location_city), Padding(padding: EdgeInsets.all(5)), Text(widget.data.formattedAddress, style: TextStyle(fontSize: 18))])),
          Padding(padding: EdgeInsets.all(15), child: Row(children: <Widget>[Icon(Icons.phone), Padding(padding: EdgeInsets.all(5)), Text(widget.data.formattedPhoneNumber, style: TextStyle(fontSize: 18))])),
          FlatButton(onPressed: () {}, child: null)
        ]));
  }
}
