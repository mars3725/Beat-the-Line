import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPlacePage extends StatefulWidget {
  final GlobalKey<FormState> _formKey2 = GlobalKey(debugLabel: "Form Key 2");
  final GlobalKey<ScaffoldState> _scaffoldKey2  = GlobalKey(debugLabel: "Scaffold Key 2");
  @override
  State createState() => NewPlacePageState();
}

class NewPlacePageState extends State<NewPlacePage> with SingleTickerProviderStateMixin {
  String _name, _description;
  int _rating;
  double _lat, _lon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: widget._scaffoldKey2,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(key: widget._formKey2,
            child: ListView(padding: EdgeInsets.all(30), children: <Widget>[
              Padding(padding: EdgeInsets.all(30)),
              TextFormField(onChanged: (name) => _name = name,
                  validator: (name) => name.isEmpty? "Name can't be empty" : null,
                  decoration: InputDecoration(labelText: "Place Name")),
              Padding(padding: EdgeInsets.all(10)),
              Row(children: <Widget>[
                Expanded(child: TextFormField(onChanged: (lat) => _lat = double.parse(lat),
                    validator: (lat) => lat.isEmpty? "Latitude can't be empty" : null,
                    decoration: InputDecoration(labelText: "Latitude"))),
                Padding(padding: EdgeInsets.all(10)),
                Expanded(child: TextFormField(onChanged: (lon) => _lon = double.parse(lon),
                    validator: (lon) => lon.isEmpty? "Longitude can't be empty" : null,
                    decoration: InputDecoration(labelText: "Longitude"))),
              ]),
              TextFormField(onChanged: (description) => _description = description,
                  validator: (description) => description.isEmpty? "Description can't be empty" : null,
                  decoration: InputDecoration(labelText: "Description Name")),
              Padding(padding: EdgeInsets.all(10)),
              TextFormField(keyboardType: TextInputType.number,
                  onChanged: (rating) => _rating = int.tryParse(rating),
                  validator: (value) {
                    var rating = int.tryParse(value);
                    if (rating == null || rating < 0 || rating > 5) return "Rating must be between 0 and 5";
                    else return null;
                  },
                  decoration: InputDecoration(labelText: "Rating")),
              Padding(padding: EdgeInsets.all(10)),
              FlatButton(color: Theme.of(context).primaryColor,
                  onPressed: () {
                if (widget._formKey2.currentState.validate()) {
                  Firestore.instance.collection('places').add({
                    "name": _name,
                    "description": _description,
                    "location": GeoPoint(_lat, _lon),
                    "rating": _rating
                  }).whenComplete(() => Navigator.of(context).pop());
                }
                  },
                  child: Padding(padding: EdgeInsets.all(10), child: Text("Submit", style: TextStyle(fontSize: 18)))),
              Padding(padding: EdgeInsets.all(30)),
            ])));
  }
}