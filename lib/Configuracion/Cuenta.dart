import 'dart:async';

import 'package:flutter/material.dart';

class Ajustes extends StatefulWidget {
  final String imagen;
  final String nombre;
  final String correo;
  final String telefono;
  Ajustes({Key key,@required this.imagen,@required this.nombre,@required this.correo,@required this.telefono});
  @override
  _AjustesState createState() => _AjustesState();
  
}

class _AjustesState extends State<Ajustes> {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController telefono = TextEditingController();

  @override
  void initState() {
    var resultado=widget.nombre.split(" ");
    nombre.text=resultado[0];
    apellidos.text=resultado[1];
    email.text=widget.correo;
    telefono.text=widget.telefono;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes",style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                padding: EdgeInsets.only(bottom: 10,top: 30),
                child: widget.imagen=="[]"||widget.imagen==null?CircleAvatar(child: Icon(Icons.face,color: Colors.white,size: 65,),radius: 50,backgroundColor: Colors.black,):CircleAvatar(radius: 50,backgroundColor: Colors.black,backgroundImage: NetworkImage(widget.imagen),),
              ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),hintText: "Nombre"),controller: nombre,),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),hintText: "Apellidos"),controller: apellidos,),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),hintText: "Correo"),controller: email,),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),hintText: "Telefono"),controller: telefono,),
            ),
          ],
        ),
      ),
    );
  }
}