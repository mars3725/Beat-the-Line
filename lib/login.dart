import 'package:BTL/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LoginPage extends StatefulWidget {
  final GlobalKey<FormState> _formKey = GlobalKey(debugLabel: "Form Key");
  final GlobalKey<ScaffoldState> _scaffoldKey  = GlobalKey(debugLabel: "Scaffold Key");
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  String _email, _password, _name;
  bool _loading, _newUser;

  @override
  void initState() {
    super.initState();
    _loading = false;
    _newUser = false;

    FirebaseAuth.instance.currentUser().then((value) {
      if (value != null) {
        syncExistingUser().then((value) => Navigator.popAndPushNamed(context, '/HomePage')).catchError((err) => print('Silent Sign In Failed'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: widget._scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Form(key: widget._formKey,
            child: ListView(padding: EdgeInsets.all(30),children: <Widget>[Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Padding(padding: EdgeInsets.all(30)),
              Image(image: AssetImage("assets/LogoOutline.png"), color: Theme.of(context).primaryColor),
              Padding(padding: EdgeInsets.all(30)),
              _newUser? TextFormField(onChanged: (name) => _name = name,
                  validator: (name) => name.isEmpty? "Name can't be empty" : null,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Name", prefixIcon: Icon(Icons.person))) : Container(),
              Padding(padding: EdgeInsets.all(10)),
              TextFormField(keyboardType: TextInputType.emailAddress, initialValue: _email, onChanged: (email) => _email = email,
                  validator: (email) {
                    if (email.isEmpty) return "Email can't be empty";
                    //else if (email.split(".").last != "edu") return "Must use a university email address";
                    else return null;
                  },
                  decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email))),
              Padding(padding: EdgeInsets.all(10)),
              TextFormField(obscureText: true, keyboardType: TextInputType.visiblePassword, onChanged: (password) => _password = password,
                  validator: (password) => password.isEmpty? "Password can't be empty" : null,
                  decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.vpn_key))),
              Padding(padding: EdgeInsets.all(10)),
              _newUser? TextFormField(obscureText: true, keyboardType: TextInputType.visiblePassword,
                  validator: (passConfirmation) => passConfirmation != _password? "Passwords must match" : null,
                  decoration: InputDecoration(labelText: "Re-enter Password", prefixIcon: Icon(Icons.vpn_key))) : Container(),
              Padding(padding: EdgeInsets.all(10)),
              _loading? CircularProgressIndicator() : FlatButton(color: Theme.of(context).primaryColor,
                  onPressed: () => _newUser? _signUp() : _signIn(),
                  child: Padding(padding: EdgeInsets.all(10), child: Text(_newUser? "Sign Up" : "Login", style: TextStyle(fontSize: 18)))),
              Padding(padding: EdgeInsets.all(30)),
            ]),
              _loading? Container() : Align(alignment: Alignment.bottomLeft, child: OutlineButton(onPressed: () => setState(() => _newUser = !_newUser), child: _newUser? Text("Already a user? Sign In!") : Text("New user? Sign Up!")))
            ])));
  }

  void _signIn() async {
    if (!widget._formKey.currentState.validate()) return;
    setState(() => _loading = true);
    print('Sign in attempt: $_email with $_password');

    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)
        .catchError((error) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("A user with that email and password was not found")));
    });
    await syncExistingUser().then((value) => Navigator.popAndPushNamed(context, '/HomePage')).catchError((err) => print(err));

    setState(() => _loading = false);
  }

  void _signUp() async {
    if (!widget._formKey.currentState.validate()) return;
    setState(() => _loading = true);
    print('Sign up attempt: $_email with $_password');

    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)
        .catchError((error) {
      widget._scaffoldKey.currentState.showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text("Cannot create a new user with the given information")));
    });
    await syncNewUser().then((value) => Navigator.popAndPushNamed(context, '/HomePage')).catchError((err) => print(err));

    setState(() => _loading = false);
  }

  Future syncExistingUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      //TODO: remove hardcoded position
      Position position = await geoLocator.getCurrentPosition();
      GeoPoint location = GeoPoint(35.9588284, -83.9384059);

      Firestore.instance.collection("users").document(user.uid).setData({
        "location": location
      }, merge: true);

      DocumentSnapshot doc = await Firestore.instance.collection("users").document(user.uid).get();
      localUser = User(user, doc.data['name'], LatLng(location.latitude, location.longitude), doc.data['rating']);
    } else throw 'no authenticated user';
  }

  Future syncNewUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      //TODO: remove hardcoded position
      Position position = await geoLocator.getCurrentPosition();
      GeoPoint location = GeoPoint(35.9588284, -83.9384059);

      int rating = 5;
      Firestore.instance.collection("users").document(user.uid).setData({
        "name": _name,
        "location": location,
        "rating": rating
      });

      localUser = User(user, _name, LatLng(location.latitude, location.longitude), rating);
    } else throw 'no authenticated user';
  }
}

User localUser;
class User {
  User(this.user, this.name, this.location, this.rating);

  FirebaseUser user;
  String name;
  LatLng location;
  int rating;
}