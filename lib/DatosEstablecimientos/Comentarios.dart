import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Comentarios extends StatefulWidget {
  @override
  _ComentariosState createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  @override
  Widget build(BuildContext context) {
    return BounceInDown(
      child: Container(
        height: 200,
        width: 200,
        child: ListView(
          children: <Widget>[
            Text("Hola")
          ],
        ),
      ),
    );
  }
}