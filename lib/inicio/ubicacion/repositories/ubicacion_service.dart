import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newapp366/inicio/ubicacion/models/ubicacion_model.dart';
class UbicacionService{
  final String _url = "https://firestore.googleapis.com/v1/projects/sensorsonico/databases/(default)/documents";

  Future <List<Ubicacion>> getCases() async {
    final url = "$_url/empresa";
    List<Ubicacion> casesList = [];
    try{
      final resp = await http.get(Uri.parse(url));
      print(json.decode(resp.body)['documents']);
      // final Map <String, dynamic> decodedData = json.decode(resp.body)['documents'];
      // print(decodedData);
      if(resp.statusCode == 200){
        return (json.decode(resp.body)['documents'] as List).map((data) => new Ubicacion.fromJson(data)).toList();
      }else {
        return [];
      }
    }catch(e){
      print ( e);
      return [];
    }
  }
}