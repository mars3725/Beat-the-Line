import 'package:BTL/login.dart';
import 'package:BTL/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
              Expanded(child: Text(widget.data.name, style: TextStyle(fontSize: 52, color: Colors.white))),
              FutureBuilder<double>(future: geoLocator.distanceBetween(localUser.location.latitude, localUser.location.longitude, widget.data.geometry.location.lat, widget.data.geometry.location.lng),
                  builder: (context, snapshot) => snapshot.hasData?
                  Align(alignment: Alignment.bottomCenter, child: Text("${(snapshot.data/1609.344).toStringAsFixed(1)}mi", style: TextStyle(fontSize: 20, color: Colors.grey))) : Container())
            ]))
          ]),
          Padding(padding: EdgeInsets.all(15), child: Row(children: <Widget>[Icon(Icons.location_city), Padding(padding: EdgeInsets.all(5)), Expanded(child: Text(widget.data.formattedAddress, style: TextStyle(fontSize: 18)))])),
          Padding(padding: EdgeInsets.all(15), child: Row(children: <Widget>[Icon(Icons.phone), Padding(padding: EdgeInsets.all(5)), Text(widget.data.formattedPhoneNumber, style: TextStyle(fontSize: 18))])),
          Spacer(),
          Container(color: Colors.orange, child: Padding(padding: EdgeInsets.all(30), child: Center(child: Text("Happy Hour 2-7 PM Today", style: TextStyle(fontSize: 24, color: Colors.indigo.shade900))))),
          Padding(padding: EdgeInsets.all(25)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 25), child: LinearPercentIndicator(progressColor: Colors.orange, backgroundColor: Colors.indigo.shade900, percent: 0.8, lineHeight: 15,)),
          Text("Occupancy 80% full"),
          Spacer(),
          FlatButton(onPressed: () {}, child: Text('Beat the Line', style: TextStyle(fontSize: 32, color: Colors.orange)), padding: EdgeInsets.all(15), color: Colors.indigo.shade900, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
          Spacer(),
          Container(height: 50, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white, Colors.orange.shade200], begin: Alignment.topCenter, end: Alignment.bottomCenter)))
        ]));
  }
}
