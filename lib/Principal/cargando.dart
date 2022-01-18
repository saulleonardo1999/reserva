import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class Buffer extends StatefulWidget{
  @override
  //final UserRepository userRepository;
  //Buffer({Key key,@required this.userRepository}):super(key:key);
  _BufferState createState() => _BufferState();
}

class _BufferState extends State<Buffer>{
  
  //UserRepository get user=>widget.userRepository;
  //bool correcto=false;
  //String email;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    //email=await user.getEmail();
  }

  @override
  Widget build(BuildContext context) {
    /*return StreamBuilder( stream: FirebaseFirestore.instance.collection("Usuarios").where(email, isEqualTo: "Correo").snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot==null){
          return 
        }
        if(snapshot.hasError){
          return null;
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting: 
          default:
          return    
        }

      },
    );
  }*/
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Bounce(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: Colors.black),
              ),
              infinite: true,
            ),
          ),
        ],
      )
    );
  }
}