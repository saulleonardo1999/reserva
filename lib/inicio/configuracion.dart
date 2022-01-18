import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp366/Configuracion/Cuenta.dart' as config;
import 'package:newapp366/Configuracion/Acercade.dart';
import 'package:newapp366/Configuracion/Soporte.dart';

class Configuracion extends StatelessWidget {
  String correo;
  String imagen;
  Configuracion({Key key,@required this.correo,@required this.imagen}):super(key:key);


  @override
  Widget build(BuildContext context) {
    print(correo);
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: correo).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return null;
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Buffer();
          default:
            String nombre;
            double xp=snapshot.data.docs.first["Xp"];
            int nivel=snapshot.data.docs.first["Nivel"];
            if(snapshot.data.docs.first["Xp"]>1){
              FirebaseFirestore.instance.collection("Usuarios").doc(snapshot.data.docs.first.id).update({"Xp":xp-1,"Nivel":(nivel+1)});
              print((xp-1).toString()+"  "+(nivel+1).toString());
            }
            nombre=snapshot.data.docs.first["Nombre"];
            return Ajustes(nombre: nombre,imagen: imagen,correo: correo,numero: snapshot.data.docs.first["Numero"],notificaciones: snapshot.data.docs.first["Notificaciones"],id: snapshot.data.docs.first.id,nivel: snapshot.data.docs.first["Nivel"],xp: snapshot.data.docs.first["Xp"],);
        }
      },
    );
  }
}

class Ajustes extends StatefulWidget{
  final String nombre;
  final String imagen;
  final String correo;
  final String numero;
  final String id;
  final int nivel;
  final double xp;
  final bool notificaciones;

  Ajustes({Key key,@required this.nivel,@required this.xp,@required this.nombre,@required this.imagen,@required this.correo,@required this.numero,@required this.notificaciones,@required this.id}):super(key:key);

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  bool nocturno=false;
  List<Color> colores=[
    Color(0xFF53E0D9),
    Color(0xFF14C1BC),
    Color(0xFFD354D6),
    Color(0xFF9E3AAF)
  ];

  Widget build(BuildContext context){
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Center(
                    child: SizedBox(
                      height: 110,
                      width: 110,
                      child: CircularProgressIndicator(
                        value: widget.xp,
                        backgroundColor: Colors.white,
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation(colores[widget.nivel]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: widget.imagen=="[]"||widget.imagen==null?CircleAvatar(child: Icon(Icons.face,color: Colors.white,size: 65,),radius: 50,backgroundColor: Colors.black,):CircleAvatar(radius: 50,backgroundColor: Colors.black,backgroundImage: NetworkImage(widget.imagen),),
                      ),
                    ),
                  ),
                ],
              ),
              Text(widget.nombre,style: TextStyle(color: Colors.black)),
              Container(
                height: 80,
                padding: EdgeInsets.only(top: 30),
                child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>config.Ajustes(imagen: widget.imagen,nombre: widget.nombre,correo: widget.correo,telefono: widget.numero,)));
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Ajustes de cuenta"),
                      Icon(Icons.face)
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: (){
                    print("Notificacion");
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Notificaciones"),
                      Padding(padding: EdgeInsets.only(),
                        child: Switch(onChanged: (value){
                        FirebaseFirestore.instance.collection("Usuarios").doc(widget.id).update({"Notificaciones":!widget.notificaciones});
                      },value: widget.notificaciones,),
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: null, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Modo nocturno"),
                      Switch(onChanged: (nocturno){
                        setState(() {
                          this.nocturno=nocturno;
                        });
                      },value: nocturno,),
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Acerca()));
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Acerca de"),
                      Icon(Icons.info_outline)
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Soporte()));
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Soporte"),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: FlatButton(
                  onPressed: (){
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Cerrar sesion"),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.black)),
                  ),
              ),
            ],
          ),
        )
      ],
    );
  }
}