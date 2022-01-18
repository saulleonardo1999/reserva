import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp366/inicio/QR.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/inicio/servicios.dart';
import 'package:newapp366/inicio/configuracion.dart';
import 'package:newapp366/inicio/ubicacion.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:provider/provider.dart';
import 'package:newapp366/UbicacionBloc/DirectionProvider.dart';

class Inicio extends StatefulWidget {
  final String nombre;
  final String imagen;
  final UserRepository _userRepository;
  Inicio({Key key,@required this.nombre,@required this.imagen,@required UserRepository userRepository})
  :assert(userRepository!=null),
  _userRepository=userRepository,
  super(key:key);

  @override
  InicioState createState() => InicioState();
}

class InicioState extends State<Inicio> {
  String get nombre => widget.nombre;
  String get imagen => widget.imagen;
  int currentIndex=0;
  UserRepository get _userRepository => widget._userRepository;
  Ubicacion ubicacion=new Ubicacion();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages=[
      Serviciosini(nombre: nombre,inicio: this,),
      Proximamente(nombre: nombre,),
      ubicacion,
      Configuracion(correo: nombre,imagen: imagen)
    ];
    return Scaffold(
        body: _pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,onTap: cambiarPagina,backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.view_carousel,color: Colors.black,),
            title: Text("Inicio",style: TextStyle(color: Colors.black),)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_rounded,color: Colors.black,),
            title: Text("QR",style: TextStyle(color: Colors.black),)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on,color: Colors.black,),
            title: Text("Mapa",style: TextStyle(color: Colors.black),)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Colors.black,),
            title: Text("Ajustes",style: TextStyle(color: Colors.black),)
          ),
        ],
        ),
      );
  }
  void cambiarPagina(int index){
    setState(() {
      currentIndex=index;     
    });
  }
  void setUbucacion(GeoPoint localizacion){
    setState(() {
      ubicacion=new Ubicacion(localizacion: localizacion,);
    });
  }
}