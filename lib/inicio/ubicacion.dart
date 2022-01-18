import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_webservice/directions.dart';
import 'package:newapp366/UbicacionBloc/DirectionProvider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as geolocation;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Ubicacion extends StatefulWidget {
  GeoPoint localizacion;
  Ubicacion({Key key, this.localizacion}) : super(key: key);
  @override
  _UbicacionState createState() => _UbicacionState(localizacion);
}

class _UbicacionState extends State<Ubicacion> {
  LatLng toPoint;
  LatLng fromPoint;
  GeoPoint localizacion;
  GoogleMapController _mapController;
  _UbicacionState(GeoPoint localizacion) {
    this.localizacion = localizacion;
    print(localizacion);
    if (localizacion != null)
      toPoint = new LatLng(localizacion.latitude, localizacion.longitude);
  }
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordenadas = [];
  PolylinePoints polylinePoints;

  @override
  void initState() {
    polylinePoints = PolylinePoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Mapa",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Consumer<DirectionProvider>(
          builder: (BuildContext context, DirectionProvider api, Widget child) {
            return GoogleMap(
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: localizacion == null ? LatLng(0, 0) : toPoint,
                zoom: 15,
              ),
              markers: localizacion == null ? null : _createMarkers(),
              myLocationEnabled: true,
              onMapCreated: _getUbicacionActual,
              polylines: _polylines,
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: FloatingActionButton(
                child: Icon(Icons.zoom_out_map),
                onPressed: _centerView,
              ),
            ),
          ],
        ));
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
        markerId: MarkerId("ToPoint"), position: toPoint, onTap: () => {}));
    return tmp;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    var lines = Provider.of<DirectionProvider>(context, listen: false);

    setPolylines();

    _centerView();
  }

  _centerView() async {
    try{
      await _mapController.getVisibleRegion();

      var left = min(this.fromPoint.latitude, this.toPoint.latitude);
      var right = max(this.fromPoint.latitude, this.toPoint.latitude);
      var top = max(this.fromPoint.longitude, this.toPoint.longitude);
      var bottom = min(this.fromPoint.longitude, this.toPoint.longitude);

      var bound = LatLngBounds(southwest: LatLng(left, bottom), northeast: LatLng(right, top));

      var cameraUpdate = CameraUpdate.newLatLngBounds(bound, 50);

      _mapController.animateCamera(cameraUpdate);
    }catch(e){

      print(e);
    }

  }

  Future<void> _getUbicacionActual(GoogleMapController controller) async {
    var point = await geolocation.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocation.LocationAccuracy.best);
    this.fromPoint = LatLng(point.latitude, point.longitude);
    _onMapCreated(controller);
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyCaARK7m5Z0JYsZCJ0Ud0I0GHh2xUhoUOc",
        PointLatLng(fromPoint.latitude, fromPoint.longitude),
        PointLatLng(toPoint.latitude, toPoint.longitude));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordenadas.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      _polylines.add(Polyline(
          width: 4,
          polylineId: PolylineId("polyLine"),
          color: Colors.black,
          points: polylineCoordenadas));
    });
  }
}
