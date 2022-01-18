import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Proximamente extends StatelessWidget{
  @override
  
  final String nombre;
  
  
  Proximamente({Key key,@required this.nombre}):super(key:key);



  Widget build(BuildContext context){
    return QR(nombre: nombre,);
  }
}


class QR extends StatefulWidget {
  final String nombre;

  QR({Key key,@required this.nombre}):super(key:key);

  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {

  String get nombre => widget.nombre;

  @override
  void initState() {
    print(nombre);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: nombre).snapshots()
    ,builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError){
        return error(context);
      }
      switch(snapshot.connectionState){
        case ConnectionState.waiting:
          return Buffer();
        default:
          String id;
          bool reservacion;
          snapshot.data.docs.forEach((DocumentSnapshot doc) {id=doc.id; reservacion=doc.data()["Reservacion"];});
          if(reservacion){
            return Reservado(context: context,id: id,);
          }else{
            return noReservado(context);
          }
      }
    });
  }
  Widget error(BuildContext context){
    return Container(
      child: Center(
        child: Text("Ha ocurrido un error",style: TextStyle(color: Colors.red),),
      ),
    );
  }
  Widget noReservado(BuildContext context){
    return Container(
      child: Center(
        child: Text("Porfavor reserva",style: TextStyle(color: Colors.black),),
      )
    );
  }
}
class Reservado extends StatelessWidget {
  BuildContext context;
  String id;
  DateTime fecha=DateTime.now();
  var hora = DateFormat('H');
  var minuto = DateFormat('m');

  Reservado({Key key,@required this.context,@required this.id}):super(key:key);

  @override
  Widget build(context) {
    
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Reservaciones").where("Usuario",isEqualTo: id).snapshots(),builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError){
        return error(context);
      }
      switch(snapshot.connectionState){
        case ConnectionState.waiting:
          return Buffer();
        default:
          if(int.parse(hora.format(fecha))==1)
            if(int.parse(minuto.format(fecha))==35){
              FirebaseFirestore.instance.collection("Usuarios").doc(id).update({"Reservacion":false});
              FirebaseFirestore.instance.collection("Reservaciones").doc(snapshot.data.docs.first.id).delete();
            }
          String qr;
          snapshot.data.docs.forEach((DocumentSnapshot doc) {qr=doc.id;});
          return Container(
            child: Center(
              child: QrImage(data: qr,size: 300,),
            ),
          );
      }    
    },);
  }
  Widget error(BuildContext context){
    return Container(
      child: Center(
        child: Text("Ha ocurrido un error",style: TextStyle(color: Colors.red),),
      ),
    );
  }
}