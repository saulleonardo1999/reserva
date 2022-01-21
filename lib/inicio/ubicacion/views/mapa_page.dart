import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newapp366/inicio/ubicacion/models/ubicacion_model.dart';
import 'package:newapp366/inicio/ubicacion/repositories/ubicacion_service.dart';
import 'dart:math' as math;

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  GoogleMapController mapController;
  String _title = "Mapa";
  Set<Polyline> polylines = Set<Polyline>();
  Set<Marker> markers = Set<Marker>();
  LatLng position = new LatLng(23.8524981, -103.1033665), _actualPlacePosition;
  Position currentLocation;
  LocationSettings locationOptions =
      LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5);
  String _geoHash;

  StreamSubscription _getPositionSubscription;
  bool loading;
  List<Ubicacion> myLocals;
  PolylinePoints polylinePoints = PolylinePoints();
  String linkImage = "";

  _getLocation() async {
    LatLng coordinates;
    bool serviceEnabled;

    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      permission = await Geolocator.requestPermission();
    }


    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      position = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13)));
      coordinates = LatLng(position.latitude, position.longitude);
    });
    _getPositionSubscription =
        Geolocator.getPositionStream().listen((Position positions) {
          var newGeoHash = Geohash.encode(positions.latitude, positions.longitude)
              .substring(0, 8);
          if (newGeoHash != _geoHash) {
            setState(() {
              _geoHash = newGeoHash;
              position =
                  LatLng(currentLocation.latitude, currentLocation.longitude);
            });
          }

          position = new LatLng(positions.latitude, positions.longitude);
          if(_actualPlacePosition != null){
            setPolylines(fromPoint: position, toPoint:  _actualPlacePosition);
          }
          coordinates = LatLng(position.latitude, position.longitude);
          return coordinates;
        });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    loading = true;
    _getLocation();
    UbicacionService().getCases().then((value) {
      myLocals = value;
      fillMarkers();
      loading = false;
      setState(() {});
    });
    super.initState();
  }

  fillMarkers() {
    markers.clear();
    myLocals.forEach((element) {
      setState(() {
        Marker resultMarker = Marker(
          markerId: MarkerId(element.fields.nombre.stringValue.toString()),
          onTap: () {
            setState(() {
              _title = element.fields.nombre.stringValue;
              LatLng point = LatLng(
                  element.fields.coordenadas.geoPointValue.latitude,
                  element.fields.coordenadas.geoPointValue.longitude
              );
              setPolylines(fromPoint: position, toPoint: point);
              LatLngBounds bounds = goToCenter(position, point);
              mapController
                  .animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
            });
          },
          position: LatLng(element.fields.coordenadas.geoPointValue.latitude,
              element.fields.coordenadas.geoPointValue.longitude
          ),
        );
        markers.add(resultMarker);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: linkImage == ""
            ? Icon(Icons.location_on)
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 7.5),
                child: CircleAvatar(
                  radius: 10.0,
                  backgroundImage: NetworkImage(linkImage),
                  backgroundColor: Colors.transparent,
                ),
              ),
        backgroundColor: Colors.black,
        title: Text(
          _title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        trafficEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        tiltGesturesEnabled: false,
        markers: markers,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        mapToolbarEnabled: true,
        rotateGesturesEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        polylines: polylines,
        initialCameraPosition: CameraPosition(
          target: position,
          zoom: 12.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.zoom_out_map,),
        backgroundColor: Colors.deepPurple,
        onPressed: _centerView,
      ),
    );
  }

  void setPolylines({LatLng fromPoint, LatLng toPoint}) async {
    try {
      List<LatLng> polylineCoordenadas = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyDYazIDcRaS6gzSTTDueTZ0Fb9kEsY43mU",
          PointLatLng(fromPoint.latitude, fromPoint.longitude),
          PointLatLng(toPoint.latitude, toPoint.longitude));
      print("Resultado " + result.points.toString());
      print(result.errorMessage);
      print(result.status);
      if (result.status == 'OK') {
        result.points.forEach((PointLatLng point) {
          polylineCoordenadas.add(LatLng(point.latitude, point.longitude));
        });
      }

      setState(() {
        polylines = Set<Polyline>();
        polylines.add(Polyline(
            width: 4,
            polylineId: PolylineId("polyLine"),
            color: Colors.deepPurple,
            points: polylineCoordenadas)
        );
      });
      // await Future.delayed(Duration(seconds: 5));
      // setPolylines(fromPoint: LatLng(fromPoint.latitude + 0.005, fromPoint.longitude - 0.005), toPoint: toPoint);
    } catch (e) {
      print(e);
    }
  }

  LatLngBounds goToCenter(LatLng origin, LatLng destination) {
    double minX = math.min(origin.latitude, destination.latitude);
    double minY = math.min(origin.longitude, destination.longitude);
    double maxX = math.max(origin.latitude, destination.latitude);
    double maxY = math.max(origin.longitude, destination.longitude);
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minX, minY),
      northeast: LatLng(maxX, maxY),
    );
    return bounds;
  }
  _centerView() async {
    try{
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 13.5)));
    }catch(e){

      print(e);
    }

  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }
}
