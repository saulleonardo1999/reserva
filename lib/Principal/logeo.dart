import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/Principal/registro.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp366/loginState/login_bloc.dart';
import 'package:newapp366/loginState/login_event.dart';
import 'package:newapp366/loginState/login_state.dart';
import 'package:newapp366/src/repository/users_repository.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;
  Login({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  String foto;
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(userRepository: _userRepository),
      child: Theme(
        userRepository: _userRepository,
      ),
    );
  }
}

class Theme extends StatelessWidget {
  final UserRepository _userRepository;
  Theme({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogeoDesign(
        userRepository: _userRepository,
      ),
      theme: ThemeData(inputDecorationTheme: InputDecorationTheme()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LogeoDesign extends StatefulWidget {
  final UserRepository _userRepository;

  LogeoDesign({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LogeoDesignState createState() => _LogeoDesignState();
}

class _LogeoDesignState extends State<LogeoDesign> {
  bool get isNotEmpty =>
      _emailcontrol.text.isNotEmpty && _passwordcontrol.text.isNotEmpty;

  bool isLoginEnabled(LoginState state) {
    return state.isFormValid && isNotEmpty && !state.isSubmitting;
  }

  final TextEditingController _emailcontrol = TextEditingController();
  final TextEditingController _passwordcontrol = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailcontrol.addListener(_emailChanged);
    _passwordcontrol.addListener(_passwordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.isSubmitting) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Buffer()));
          }
          if (state.isFailature) {
            Navigator.of(context).pop();
          }
          if (state.isSuccess) {
            Navigator.of(context).pop();
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
          if (state.isSuccessGoogle) {
            Navigator.of(context).pop();
            print("Google");
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },
        child: Stack(
          children: [
            Background(
              assets: "assets/images/Backgraound.jpg",
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.only(),
                child: GestureDetector(
                  onTapCancel: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      child: BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                        return Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 390),
                                  child: logeo(context, state),
                                ),
                                boton_logeo(context, state),
                                logeoGoogle(context, state)
                              ],
                            )
                          ],
                        );
                      }),
                    ),
                  ),
                  onTap: () {
                    final FocusScopeNode focus = FocusScope.of(context);
                    if (!focus.hasPrimaryFocus && focus.hasFocus) {
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                ),
              ),
              floatingActionButton: new FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => new RegsitroNormal(
                                userRepository: _userRepository)));
                  },
                  child: new Icon(
                    Icons.border_color,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white),
            )
          ],
        ));
  }

  Widget imagen(BuildContext context) {
    String _imagen = "";
    if (_imagen == "") {
      return new Container(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: new CircleAvatar(
          child: new Icon(
            Icons.account_circle,
            size: 90,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          radius: 90,
        ),
      );
    } else {
      return new Container(
        padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: new CircleAvatar(
          child: new Icon(
            Icons.add,
            size: 90,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          radius: 90,
        ),
      );
    }
  }

  String _usuario;
  String _password;
  @override
  Widget logeo(BuildContext context, LoginState state) {
    return new Container(
      padding: EdgeInsets.only(top: 20, left: 40, right: 40),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 10),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (String str) {
                this._usuario = str;
              },
              autocorrect: false,
              textAlign: TextAlign.center,
              // autovalidate: true,
              controller: _emailcontrol,
              validator: (_) {
                return !state.isEmailValid ? 'Contraseña invalida' : null;
              },
              style: TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF14C1BC))),
                fillColor: Colors.transparent,
                filled: true,
                hintText: "Usuario",
                hintStyle: TextStyle(color: Color(0xFF14C1BC), fontSize: 22),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF14C1BC))),
              ),
            ),
          ),
          new Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new TextFormField(
                controller: _passwordcontrol,
                validator: (_) {
                  return !state.isPasswordValid ? 'Contraseña invalida' : null;
                },
                obscureText: true,
                textAlign: TextAlign.center,
                autocorrect: false,
                // autovalidate: true,
                onChanged: (String str) {
                  this._password = str;
                },
                style: TextStyle(color: Colors.white),
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.red, width: 80)),
                  fillColor: Colors.transparent,
                  filled: true,
                  hintText: "Contraseña",
                  hintStyle: TextStyle(color: Color(0xFF14C1BC), fontSize: 22),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xFF14C1BC))),
                ),
              ))
        ],
      ),
    );
  }

  Widget boton_logeo(BuildContext context, LoginState state) {
    return new Container(
        width: 300,
        height: 75,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: new FlatButton(
          onPressed: _submitting,
          child: new Text(
            "Login",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Color(0xFF9E3AAF), width: 3.5)),
          splashColor: Colors.black,
          color: Color(0xFF53E0D9),
        ));
  }

  void _submitting() {
    _loginBloc.add(
        LoginEandP(email: _emailcontrol.text, password: _passwordcontrol.text));
  }

  Widget logeoGoogle(BuildContext context, LoginState state) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          FlatButton(
            child: Image.asset(
              "assets/images/GoogleLogo.png",
              height: 30,
              width: 30,
            ),
            onPressed: () {
              try {
                _loginBloc.add(LoginWithGoogle());
              } catch (_) {
                print(_.toString());
              }
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailcontrol.dispose();
    _passwordcontrol.dispose();
    super.dispose();
  }

  void _emailChanged() {
    _loginBloc.add(EmailChanged(email: _emailcontrol.text));
  }

  void _passwordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordcontrol.text));
  }
}

class Background extends StatelessWidget {
  String assets;
  Background({Key key, @required this.assets}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(fit: BoxFit.cover, image: AssetImage(assets))),
      ),
    );
  }
}

class PhoneGoogle extends StatefulWidget {
  UserRepository _userRepository;

  PhoneGoogle({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        this._userRepository = userRepository,
        super(key: key);
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<PhoneGoogle> {
  String _phone = "";
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
              padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (cargandoEnvio)
                        ? CircularProgressIndicator()
                        : Text("Confirma tu numero de telefono!"),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 100, right: 30, left: 30),
                      child: Row(
                        children: [
                          CountryCodePicker(
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
                            onInit: (txt) {
                              if (_phone.isEmpty) {
                                _phone = txt.code;
                              } else {
                                _phone = txt.code + _phone;
                              }
                            },
                          ),
                          Expanded(
                            child: TextField(
                              autocorrect: false,
                              decoration: InputDecoration(
                                  hintText: "Telefono",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                              keyboardType: TextInputType.phone,
                              onChanged: (txt) {
                                _phone += txt;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: Container(
              height: 75,
              width: 270,
              padding:
                  EdgeInsets.only(top: 15, left: 140, bottom: 15, right: 10),
              child: FlatButton(
                onPressed: () async {
                  if (await widget._userRepository.isSignedIn()) {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                        LoggedInGoolge(
                            numero: this._phone.toString(),
                            userRepository: widget._userRepository));
                  } else {
                    var validacion;
                    try {
                      setState(() {
                        cargandoEnvio = true;
                      });
                      validacion = await FirebaseFirestore.instance
                          .collection("Usuarios")
                          .where("Numero", isEqualTo: this._phone.toString())
                          .get();
                    } catch (_) {
                      validacion = "[r]";
                      print("Error con firebase por: " + _.toString());
                    }
                    if (validacion.docs.toString() == "[]") {
                      setState(() {
                        cargandoEnvio = true;
                      });
                      _firebaseAuth.verifyPhoneNumber(
                        phoneNumber: _phone.toString(),
                        forceResendingToken: 30,
                        timeout: Duration(seconds: 30),
                        verificationCompleted: (_) {
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
                          setState(() {
                            verificacion = false;
                            cargandoEnvio = false;
                            cargando = false;
                          });
                        },
                      );
                    } else {
                      BlocProvider.of<AuthenticationBloc>(context).add(Ready());
                    }
                  }
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
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedInGoolge(
                  numero: this._phone.toString(),
                  userRepository: widget._userRepository));

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
