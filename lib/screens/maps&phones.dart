import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget {
  static const routeName = '/map';
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  var currentLocation;
  Future<void> _launched;
  String _phone = '103';

  @override
  void initState() {
    _getLocation();
    super.initState();
  }

  _getLocation() async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      print("locationLatitude: ${currentLocation.latitude}");
      print("locationLongitude: ${currentLocation.longitude}");
      setState(
          () {}); //rebuild the widget after getting the current location of the user
    } on Exception {
      currentLocation = null;
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 48.0),
            child: Text('Hospital Locations'),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.ambulance,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => setState(() {
                  _launched = _makePhoneCall('tel:$_phone');
                }),
              ),
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            _map(context),
            _buildContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 150.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/norvic.jfif", 27.6900, 85.3191,
                    "Norvic Hospital"),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/birhospital.jpg", 27.7048, 85.3137,
                    "Bir Hospital"),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/medicity.jfif", 27.662199,
                    85.302915, "Nepal Mediciti Hospital"),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/civil.jfif", 27.686579, 85.338750,
                    "Civil Hospital"),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/alka_hospital.jfif", 27.674679,
                    85.315362, "Alka Hospital"),
              ),
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/civil.jfif", 27.693321, 85.314143,
                    "Nepal Eye Hospital"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/sumeru.jfif", 27.676175, 85.314776,
                    "Sumeru City Hospital"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _boxes("assets/image/bluecross.jfif", 27.693806,
                    85.315231, "Blue Cross Hospital"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget hospitalDetails(String hospitalName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            hospitalName,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                child: Text(
              "4.1",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
              child: Icon(
                FontAwesomeIcons.solidStarHalf,
                color: Colors.amber,
                size: 15.0,
              ),
            ),
            Container(
                child: Text(
              "(946)",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
          ],
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Open \u00B7 Emergency 24 Hrs",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Open \u00B7 OPD closes 21:00 Pm",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image.asset(
                        _image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: hospitalDetails(restaurantName),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _map(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(27.7048, 85.3137), zoom: 15),
        onMapCreated: (GoogleMapController controller) =>
            _controller.complete(controller),
        markers: {
          norvicMarker,
          birHospitalMarker,
          alkaMarker,
          bluecrossMarker,
          civilMarker,
          eyeMarker,
          medicityMarker,
          sumeruMarker
        },
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

Marker norvicMarker = Marker(
    markerId: MarkerId('norvicMarker'),
    position: LatLng(27.6900, 85.3191),
    infoWindow: InfoWindow(title: 'Norvic Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

Marker birHospitalMarker = Marker(
    markerId: MarkerId('birHospitalMarker'),
    position: LatLng(27.7048, 85.3137),
    infoWindow: InfoWindow(title: 'Bir Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker sumeruMarker = Marker(
    markerId: MarkerId('sumeruhospitalMarker'),
    position: LatLng(27.676175, 85.314776),
    infoWindow: InfoWindow(title: 'Sumeru City Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker alkaMarker = Marker(
    markerId: MarkerId('alkaMarker'),
    position: LatLng(27.674679, 85.315362),
    infoWindow: InfoWindow(title: 'Alka Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker bluecrossMarker = Marker(
    markerId: MarkerId('bluecrossMarker'),
    position: LatLng(27.693806, 85.315231),
    infoWindow: InfoWindow(title: 'Blue Cross Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker eyeMarker = Marker(
    markerId: MarkerId('eyehospitalMarker'),
    position: LatLng(27.693321, 85.314143),
    infoWindow: InfoWindow(title: 'Nepal Eye Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker civilMarker = Marker(
    markerId: MarkerId('civilMarker'),
    position: LatLng(27.686579, 85.338750),
    infoWindow: InfoWindow(title: 'Civil Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
Marker medicityMarker = Marker(
    markerId: MarkerId('medicityhospitalMarker'),
    position: LatLng(27.662199, 85.302915),
    infoWindow: InfoWindow(title: 'Nepal Mediciti Hospital'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
