import 'package:newapp366/loginState/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:newapp366/Principal/registro.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp366/registerState/register_bloc.dart';
import 'package:newapp366/registerState/register_event.dart';
import 'package:newapp366/registerState/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserRepository{
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
  :_firebaseAuth=firebaseAuth??FirebaseAuth.instance,
  _googleSignIn=googleSignIn??GoogleSignIn();
  
  Future<User> singnInWithGoogle() async{
    final GoogleSignInAccount googleUser=await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth=await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken,idToken: googleAuth.idToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser;
  }

  Future<String> validatePhone(String phone,BuildContext context,String nombre,String apellidos,String password,String correo){
    print(phone);
    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      forceResendingToken: 30,
      timeout: Duration(seconds: 30),
      verificationCompleted: (_){
        print("Complete");
      }, 
      verificationFailed: (ex){
        print("Error de envio"+ex.toString());
      }, 
      codeSent: (String verificationId,[int forcedResendingtoken]){
        //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Confirmacion(context: context, verification: verificationId, nombre: nombre, apellidos: apellidos, password: password, correo: correo, numero: phone, firebaseAuth: _firebaseAuth)));
        print("Enviado");
      }, 
      codeAutoRetrievalTimeout: (_){
        print("Termino");
      },
      );
  }

  Future<void> signInWhitCredentials(String email,String password){
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email,String password) async{
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> singOut(){
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut()
    ]);
  }
  
  Future<bool> isSigedAwait() async{
    final _cuurenUser=_firebaseAuth.authStateChanges();
    return _cuurenUser!=null;
  }

  Future<bool> isSignedIn() async{
    final currentUser=_firebaseAuth.currentUser;
    return currentUser!=null;
  }

  Future<String> getUser() async{
    return _firebaseAuth.currentUser.displayName;
  }
  Future<String> getPic() async{
    return _firebaseAuth.currentUser.photoURL;
  }
  Future<String> getEmail() async{
    return _firebaseAuth.currentUser.email;
  }
  Future<void> getid() async{
    FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: await this.getEmail()).snapshots().listen((data)=>data.docs.forEach((doc) {print(doc.id);})); 
  }
  Future<String> getPhone() async{
    return _firebaseAuth.currentUser.phoneNumber;
  }
  















}

//_______________________________________________________WIDGETVERIFICACION_________________________________________________________




class Confirmacion extends StatelessWidget {
  
  BuildContext context;
  String verification;
  String nombre;
  String apellidos;
  String password;
  String correo;
  String numero;

  final FirebaseAuth firebaseAuth;


  Confirmacion({Key key,@required this.context,@required this.verification,@required this.nombre,@required this.apellidos,@required this.password,@required this.correo,@required this.numero,@required this.firebaseAuth}):super(key:key);


  final _codeController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    context=this.context;
    return Scaffold(
      appBar: AppBar(title: Text("Ultimo Paso"),backgroundColor: Colors.black,),
      body: Center(
        heightFactor: 700,
        child: Container(
          padding: EdgeInsets.only(top:200,left:20,right: 20),
          child: Column(
            children: <Widget>[
              TextFormField(decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(3)),hintText: "Codigo"),controller: _codeController,keyboardType: TextInputType.phone,),
              Padding(padding: EdgeInsets.only(top:30),
                child: Text("Este es el utlimo paso para poder empezar"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
            height: 75,
            width: 270,
            padding: EdgeInsets.only(top: 15,left: 140,bottom: 15,right: 10),
            child: FlatButton(
              onPressed: (){
                try{
                  var _credential= PhoneAuthProvider.credential(verificationId: verification, smsCode: _codeController.text.trim());
                  firebaseAuth.signInWithCredential(_credential).then((value){
                    BlocProvider.of<RegistroBloc>(context).add(RegistroClick(apellidos: apellidos,nombre: nombre,email: correo,password: password,numero: numero));
                  }).catchError((e){print(e);});
                }catch(_){
                  print(_);
                }
              },
              child: new Text("RESERVA",style: TextStyle(color: Colors.white),),
              shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.transparent)),
              splashColor: Colors.yellow,
              color: Colors.black,
            ),
          ),
    );
  }
}