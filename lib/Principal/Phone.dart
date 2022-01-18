import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:newapp366/registerState/register_bloc.dart';
import 'package:newapp366/registerState/register_event.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Phone extends StatefulWidget {
  String nombre;
  String apellidos;
  String correo;
  String password;
  Phone(
      {Key key,
      @required this.nombre,
      @required this.apellidos,
      @required this.correo,
      @required this.password})
      : super(key: key);
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String _phone;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  final _codeController = TextEditingController();
  bool verificacion = false;
  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return (verificacion)
        ? message()
        : Scaffold(
            appBar: AppBar(
              title: Text("Confirmacion de registro",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              backgroundColor: Colors.black,
            ),
            body: Center(
                child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: CountryCodePicker(
                    initialSelection: 'MX',
                    onInit: (txt) {
                      if (_phone.isEmpty) {
                        _phone = txt.code;
                      } else {
                        _phone = txt.code + _phone;
                      }
                    },
                    /*onInputChanged: (phone){
                    this._phone=phone;
                    print(_phone);
                  },
                  hintText: "Telefono",
                  countries: [
                    'US',
                    'MX'
                  ],
                  formatInput: true,
                  inputDecoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),labelText: "Telefono"),
                  keyboardType: TextInputType.phone,
                  selectorConfig: SelectorConfig(leadingPadding: 0,useEmoji: true,),*/
                  ),
                ),
                TextField(
                  onChanged: (txt) {
                    _phone += txt;
                  },
                )
              ],
            )),
            floatingActionButton: Container(
              height: 75,
              width: 270,
              padding:
                  EdgeInsets.only(top: 15, left: 140, bottom: 15, right: 10),
              child: FlatButton(
                onPressed: () async {
                  _firebaseAuth.verifyPhoneNumber(
                    phoneNumber: _phone.toString(),
                    forceResendingToken: 30,
                    timeout: Duration(seconds: 30),
                    verificationCompleted: (_) {
                      //BlocProvider.of<RegistroBloc>(context).add(RegistroClick(apellidos: widget.apellidos,nombre: widget.nombre,email: widget.correo,password: widget.password,numero: _phone.toString()));
                      print("Complete");
                    },
                    verificationFailed: (ex) {
                      print("Error de envio" + ex.toString());
                    },
                    codeSent: (String verificationId,
                        [int forcedResendingtoken]) {
                      this._verificationId = verificationId;
                      setState(() {
                        verificacion = true;
                      });
                    },
                    codeAutoRetrievalTimeout: (_) {
                      print("Termino");
                    },
                  );
                },
                child: new Text(
                  "Siguiente",
                  style: TextStyle(color: Colors.white),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(color: Colors.transparent)),
                splashColor: Colors.yellow,
                color: Colors.black,
              ),
            ),
          );
  }

  Widget message() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ultimo Paso"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        heightFactor: 700,
        child: Container(
          padding: EdgeInsets.only(top: 200, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3)),
                    hintText: "Codigo"),
                controller: _codeController,
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: (cargando)
                    ? CircularProgressIndicator()
                    : Text(
                        "Este es el utlimo paso para poder empezar a reservar"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 75,
        width: 270,
        padding: EdgeInsets.only(top: 15, left: 140, bottom: 15, right: 10),
        child: FlatButton(
          onPressed: () async {
            setState(() {
              cargando = true;
            });
            try {
              var _credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId,
                  smsCode: _codeController.text.trim());
              await _firebaseAuth.signInWithCredential(_credential);
              BlocProvider.of<RegistroBloc>(context).add(RegistroClick(
                  apellidos: widget.apellidos,
                  nombre: widget.nombre,
                  email: widget.correo,
                  password: widget.password,
                  numero: _phone.toString()));
              print("Finalize");
            } catch (_) {
              print("Error de autenticacion por:   " + _.toString());
            }
          },
          child: new Text(
            "RESERVA",
            style: TextStyle(color: Colors.white),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide(color: Colors.transparent)),
          splashColor: Colors.yellow,
          color: Colors.black,
        ),
      ),
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      //_phone=internationalizedPhoneNumber;
      //print(internationalizedPhoneNumber);
    });
  }
}
