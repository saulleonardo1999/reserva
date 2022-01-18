// import 'dart:convert' as convert;
// import 'dart:io' show Platform;
// import 'dart:math' as math;
//
// import 'package:geocoder/geocoder.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart' as MapsPlaces;
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:location/location.dart';
//
// class MapController {
//   String os = Platform.operatingSystem; //in your code
//
//   final places = MapsPlaces.GoogleMapsPlaces(
//       apiKey: 'AIzaSyDWDujRNzJH919Z2NuHUBXyj39Pz1MjEHA');
//   String url;
//
//   Future getNameFromLatLng(LatLng place) async {
//     final coordinates = new Coordinates(double.parse(place.latitude.toString()),
//         double.parse(place.longitude.toString()));
//     var addresses =
//     await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     var first = addresses.first;
//     return '${first.addressLine}';
//   }
//
//   Future getPlaces(String text) async {
//     MapsPlaces.PlacesAutocompleteResponse res = await places.autocomplete(text);
//     if (res.isOkay) return res.predictions;
//   }
//
//   Future<MapsPlaces.PlaceDetails> getPlaceDetails(
//       MapsPlaces.Prediction prediction) async {
//     MapsPlaces.PlacesDetailsResponse res =
//     await places.getDetailsByPlaceId(prediction.placeId);
//     if (res.isOkay)
//       return res.result;
//     else
//       return null;
//   }
//
//   Future getImage() async {
//     var image =
//     await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 800);
//
//     return image;
//   }
//
//   Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
//     url =
//     "https://maps.googleapis.com/maps/api/directions/json?&mode=driving&origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=AIzaSyDWDujRNzJH919Z2NuHUBXyj39Pz1MjEHA";
//     var response = await http.get(url);
//     if (response.statusCode == 200) {
//       var routes = convert.jsonDecode(response.body)['routes'];
//       if (routes.length > 0) {
//         var a = routes[0]['overview_polyline'];
//         return decodePolyPoints(a['points']);
//       } else
//         return null;
//     } else {
//       return null;
//     }
//   }
//
//   List<LatLng> decodePolyPoints(String encodedPath) {
//     int len = encodedPath.length;
//
//     final List<LatLng> path = new List<LatLng>();
//     int index = 0;
//     int lat = 0;
//     int lng = 0;
//
//     while (index < len) {
//       int result = 1;
//       int shift = 0;
//       int b;
//       do {
//         b = encodedPath.codeUnitAt(index++) - 63 - 1;
//         result += b << shift;
//         shift += 5;
//       } while (b >= 0x1f);
//       lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//
//       result = 1;
//       shift = 0;
//       do {
//         b = encodedPath.codeUnitAt(index++) - 63 - 1;
//         result += b << shift;
//         shift += 5;
//       } while (b >= 0x1f);
//       lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
//
//       path.add(new LatLng(lat * 1e-5, lng * 1e-5));
//     }
//
//     return path;
//   }
//
//   Future getLocation(Location locationService) async {
//     return await locationService.getLocation();
//     /*await locationService.changeSettings(accuracy: LocationAccuracy.HIGH);
//     try {
//       bool serviceStatus = await locationService.serviceEnabled();
//       if (serviceStatus) {
//         bool _permission = await locationService.requestPermission();
//         if (_permission) {
//           return await locationService.getLocation();
//         }
//       } else {
//         bool serviceStatusResult = await locationService.requestService();
//         if (serviceStatusResult) {
//           getLocation(locationService);
//         }
//       }
//     } on PlatformException catch (e) {
//
//     }*/
//   }
//
//   LatLngBounds goToCenter(LatLng origin, LatLng destination) {
//     double minX = math.min(origin.latitude, destination.latitude);
//     double minY = math.min(origin.longitude, destination.longitude);
//     double maxX = math.max(origin.latitude, destination.latitude);
//     double maxY = math.max(origin.longitude, destination.longitude);
//     LatLngBounds bounds = LatLngBounds(
//       southwest: LatLng(minX, minY),
//       northeast: LatLng(maxX, maxY),
//     );
//     return bounds;
//   }
// }