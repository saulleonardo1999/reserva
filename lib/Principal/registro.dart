import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:newapp366/registerState/register_bloc.dart';
import 'package:newapp366/registerState/register_event.dart';
import 'package:newapp366/registerState/register_state.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegsitroNormal extends StatelessWidget {
  final UserRepository _userRepository;

  RegsitroNormal({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegistroBloc>(
        create: (context) => RegistroBloc(
              userRepository: _userRepository,
            ),
        child: Registro(
          userRepository: _userRepository,
        ));
  }
}

class Registro extends StatefulWidget {
  final UserRepository _userRepository;

  Registro({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String nombre;
  String apellidos;
  String password;
  String repite;
  String email;

  RegistroBloc _registroBloc;

  TextEditingController _nombreControl = TextEditingController();
  TextEditingController _apellidosControl = TextEditingController();
  TextEditingController _passwordControl = TextEditingController();
  TextEditingController _emailControl = TextEditingController();
  TextEditingController _repite = TextEditingController();

  String _phone;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _verificationId;
  final _codeController = TextEditingController();
  bool verificacion = false;
  bool cargando = false;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registroBloc = BlocProvider.of<RegistroBloc>(context);
    _passwordControl.addListener(_passwordChanged);
    _emailControl.addListener(_emailChanged);
  }

  bool get isNotEmpty =>
      _passwordControl.text.isNotEmpty &&
      _emailControl.text.isNotEmpty &&
      _nombreControl.text.isNotEmpty &&
      _apellidosControl.text.isNotEmpty;

  bool registroValido(RegistroState state) {
    return state.isFormValid && isNotEmpty && !state.submiting && passwordValid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _passwordControl.dispose();
    _emailControl.dispose();
    _nombreControl.dispose();
    _apellidosControl.dispose();
    _repite.dispose();
  }

  void _emailChanged() {
    _registroBloc.add(EmailChanged(email: _emailControl.text));
  }

  void _passwordChanged() {
    _registroBloc.add(PasswordChanged(password: _passwordControl.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistroBloc, RegistroState>(
        listener: (context, state) {
      if (state.isFailature) {
        Navigator.of(context).pop();
      }
      if (state.submiting) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Buffer()));
      }
      if (state.isSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return register(context, state);
      },
    ));
  }

  Widget register(BuildContext context, RegistroState state) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Registro",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            fondo_superior(context),
            parte_registro(context, state)
          ],
        ));
  }

  Widget parte_registro(BuildContext context, RegistroState state) {
    return Container(
        padding: EdgeInsets.all(25),
        width: 300,
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Nombre",
                    filled: true,
                    fillColor: Colors.white),
                onChanged: (String str) {
                  this.nombre = str;
                },
                controller: _nombreControl,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Apellidos",
                    filled: true,
                    fillColor: Colors.white),
                onChanged: (String str) {
                  this.apellidos = str;
                },
                controller: _apellidosControl,
              ),
            ),
            correo(context, state),
            Container(
              padding: EdgeInsets.only(top: 25),
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Contraseña",
                    filled: true,
                    fillColor: Colors.white),
                controller: _passwordControl,
                // autovalidate: true,
                obscureText: true,
                validator: (_) {
                  return !state.isPasswordValid
                      ? 'La coontraseña no es valida (1 mayuscula 1 numero)'
                      : null;
                },
                onChanged: (String str) {
                  this.password = str;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Repite Contraseña",
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (String str) {
                  this.repite = str;
                },
                validator: (_) {
                  return (_passwordControl.text != _repite.text)
                      ? "Las contraseñas no coinsiden"
                      : null;
                },
                controller: _repite,
                obscureText: true,
              ),
            ),
            Container(
              height: 75,
              width: 270,
              padding: EdgeInsets.only(top: 30, left: 140),
              child: FlatButton(
                onPressed: () {
                  BuildContext anterior = context;
                  print("Contexto: " + anterior.toString());
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Phone(
                            apellidos: apellidos,
                            nombre: nombre,
                            correo: email,
                            password: password,
                            registro: anterior,
                          )));
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
            )
          ],
        ));
  }

  Widget correo(BuildContext context, RegistroState state) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: TextFormField(
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintText: "Correo",
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: TextInputType.emailAddress,
        key: Key("CorreoTextField"),
        autocorrect: true,
        controller: _emailControl,
        // autovalidate: true,
        validator: (_) {
          return !state.isEmailValid ? 'Correo invalido' : null;
        },
        onChanged: (str) {
          this.email = str;
        },
      ),
    );
  }

  Widget fondo_superior(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Fondo.jpg"), fit: BoxFit.cover)),
      width: 400,
      height: 150,
    );
  }

  bool get passwordValid => repite == _passwordControl.text;
}

class Phone extends StatefulWidget {
  String nombre;
  String apellidos;
  String correo;
  String password;
  BuildContext registro;

  Phone(
      {Key key,
      @required this.nombre,
      @required this.apellidos,
      @required this.correo,
      @required this.password,
      @required this.registro})
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
  bool cargandoEnvio = false;

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
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 180, 0, 0),
              child: Center(
                  child: Column(
                children: [
                  (cargandoEnvio)
                      ? CircularProgressIndicator()
                      : Text("Confirma tu numero de telefono!"),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          CountryCodePicker(
                            initialSelection: 'MX',
                            onInit: (txt) {
                              _phone = txt.code;
                            },
                            /*onInputChanged: (phone) {
                              this._phone = phone;
                              print(_phone);
                            },
                            hintText: "Telefono",
                            countries: ['US', 'MX'],
                            formatInput: true,
                            inputDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black)),
                                labelText: "Telefono"),
                            keyboardType: TextInputType.phone,
                            selectorConfig: SelectorConfig(
                              leadingPadding: 0,
                              useEmoji: true,
                            ),*/
                          ),
                          TextField(
                            onChanged: (txt) {
                              _phone += txt;
                            },
                            keyboardType: TextInputType.phone,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
            floatingActionButton: Container(
              height: 75,
              width: 270,
              padding:
                  EdgeInsets.only(top: 15, left: 140, bottom: 15, right: 10),
              child: FlatButton(
                onPressed: () async {
                  setState(() {
                    cargandoEnvio = true;
                  });
                  _firebaseAuth.verifyPhoneNumber(
                    phoneNumber: _phone.toString(),
                    forceResendingToken: 30,
                    timeout: Duration(seconds: 30),
                    verificationCompleted: (_) {
                      print(widget.registro.toString());
                      BlocProvider.of<RegistroBloc>(widget.registro).add(
                          RegistroClick(
                              apellidos: widget.apellidos,
                              nombre: widget.nombre,
                              email: widget.correo,
                              password: widget.password,
                              numero: _phone.toString()));
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
              var credential = PhoneAuthProvider.credential(
                  verificationId: _verificationId,
                  smsCode: _codeController.text.trim());
              print("Valida bro: " + credential.toString());
              await _firebaseAuth.signInWithCredential(credential);
              BlocProvider.of<RegistroBloc>(widget.registro).add(RegistroClick(
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
