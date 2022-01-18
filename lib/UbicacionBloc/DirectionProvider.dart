import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class DirectionProvider extends ChangeNotifier{

  Set<maps.Polyline> _polylines = Set();
  List<maps.LatLng> polylineCoordenadas = [];
  PolylinePoints polylinePoints=PolylinePoints();

  Set<maps.Polyline> get currentRoute => _polylines;

  Future<void> findDirections(maps.LatLng from,maps.LatLng to)async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyCaARK7m5Z0JYsZCJ0Ud0I0GHh2xUhoUOc",
      PointLatLng(from.latitude, from.longitude), 
      PointLatLng(to.latitude, to.longitude)
    );

    Set<maps.Polyline> newRoute = Set();

    if(result.status == 'OK'){
      result.points.forEach((PointLatLng point) {
        polylineCoordenadas.add(maps.LatLng(point.latitude,point.longitude));
      });
    }

    var line= maps.Polyline(
        width: 4,
        polylineId: maps.PolylineId("polyLine"),
        color: Colors.black,
        points: polylineCoordenadas
      );

    newRoute.add(line);
    _polylines=newRoute;

  }
}