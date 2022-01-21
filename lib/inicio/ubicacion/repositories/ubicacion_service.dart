import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:newapp366/inicio/ubicacion/models/ubicacion_model.dart';
class UbicacionService{
  final String _url = "https://firestore.googleapis.com/v1/projects/pruebaapp367/databases/(default)/documents";

  Future <List<Ubicacion>> getCases() async {
    final url = "$_url/Establecimientos";
    List<Ubicacion> casesList = [];
    try{
      final resp = await http.get(Uri.parse(url));
      // print(resp.body);
      // print(json.decode(resp.body)['documents']);
      // final Map <String, dynamic> decodedData = json.decode(resp.body)['documents'];
      // print(decodedData);
      if(resp.statusCode == 200){
        List<Ubicacion> ubicaciones = (json.decode(resp.body)['documents'] as List).map((data) => new Ubicacion.fromJson(data)).toList();
        print(ubicaciones);
        return ubicaciones;

      }else {
        return [];
      }
    }catch(e){
      print ( e);
      return [];
    }
  }
}