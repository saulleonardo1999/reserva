import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReservacionState extends StatelessWidget {
  bool estado;
  String idusuario;
  BuildContext context;
  String establecimiento;
  AnimationController control;

  ReservacionState({Key key,@required this.control,@required this.estado,@required this.idusuario,@required this.establecimiento,@required BuildContext context}):
  this.context=context,
  super(key:key);
  @override
  Widget build(context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Reservaciones").where("Usuario",isEqualTo: idusuario).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          print("Error");
          return null;
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting: print("Cargando");return cargando(context);
          default:
            String idreservacion;
            snapshot.data.docs.forEach((doc) {
              idreservacion=doc.id;
            });
            if(estado)
              return ReservacionCancelada(idreservacion: idreservacion,idusuario: idusuario,context: context,control: control,);
            else
              return ReservacionExitosa(context: context,establecimiento: establecimiento,usuario: idusuario,control: control,);
        }
      },
    );
  }
  Widget cargando(BuildContext context){
    return CupertinoAlertDialog(
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
class ReservacionCancelada extends StatelessWidget {
  String idreservacion;
  String idusuario;
  BuildContext context;
  AnimationController control;

  ReservacionCancelada({Key key,@required this.idreservacion,@required this.idusuario,@required BuildContext context,@required this.control}):
  this.context=context,
  super(key:key);
  @override
  Widget build(context) {
    return CupertinoAlertDialog(
      title: Text("Cancelar Resrevacion"),
      content: Padding(padding: EdgeInsets.only(top:30,bottom:30),
        child: Text("Deseas cancelar tu reservacino actual"),
      ),
      actions: <Widget>[
        FlatButton(child: Text("Cancelar"),onPressed: (){Navigator.of(context).pop();},),
        FlatButton(onPressed: (){
          FirebaseFirestore.instance.collection("Reservaciones").doc(idreservacion).delete();
          FirebaseFirestore.instance.collection("Usuarios").doc(idusuario).update({"Reservacion":false});
          Navigator.of(context).pop();
          control.reverse();
        }, child: Text("Aceptar"))
      ],
    );
  }
}
class ReservacionExitosa extends StatelessWidget {
  TextEditingController controller=new TextEditingController();
  String establecimiento;
  String usuario;
  BuildContext context;
  AnimationController control;

  ReservacionExitosa({Key key,@required this.establecimiento,@required this.usuario,@required this.context,@required this.control}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Aceptar Resrevacion"),
      content: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top:30,bottom:30),child: 
              TextField(
                decoration: InputDecoration(
                  labelText: "No. personas",
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
                controller: controller,
             ),)
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(child: Text("Cancelar"),onPressed: (){Navigator.of(context).pop();},),
        FlatButton(onPressed: (){
          FirebaseFirestore.instance.collection("Reservaciones").doc().set({"Establecimiento":this.establecimiento,"Hora y fecha":DateTime.now(),"No. Personas":controller.text,"Usuario":this.usuario});
          FirebaseFirestore.instance.collection("Usuarios").doc(usuario).update({"Reservacion":true});
          Navigator.of(context).pop();
          control.forward();
          return showDialog(context: context,builder: (context){
            return CupertinoAlertDialog(
              title: Text("Exitosa"),
              content: Padding(padding: EdgeInsets.only(top: 30,bottom: 30),child: Text("Reservacion creada con exito"),),
              actions: <Widget>[
                FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Aceptar"))
              ],
            );
          });
        }, child: Text("Aceptar"))
      ],
    );
  }
}