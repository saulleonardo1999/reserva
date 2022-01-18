import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/Principal/logeo.dart';
import 'package:newapp366/UbicacionBloc/DirectionProvider.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_state.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/inicio/inicio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  //BlocSupervisor.delegate=SimpleBlocDelegate();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final UserRepository userRepository=UserRepository();
  runApp(
    ChangeNotifierProvider(create: (_)=>DirectionProvider(),
      child: App(userRepository: userRepository),
    ),
    );
}

class App extends StatefulWidget {
  final UserRepository _userRepository;
  @override
  App({Key key,UserRepository userRepository})
    :assert(userRepository!=null),
    _userRepository=userRepository,
    super(key:key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>{
  String conexion;

    Widget build(BuildContext context){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: widget._userRepository)
      ..add(AppStarted()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false
        ,home: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        builder: (context,state){
          if(state is Unitialized){
            return Buffer();
          }
          if(state is Authenicated){
            print(state.displayName.toString());
            return Inicio(nombre: state.displayName,imagen: state.imagen,userRepository: widget._userRepository,);
            //return (state.displayName!=null)?Inicio(nombre: state.displayName,imagen: state.imagen,userRepository: _userRepository,)
            //:Login(userRepository: _userRepository);
          }
          if(state is Unauthenticated){
            print("No aut");
            return Login(userRepository: widget._userRepository,);
          }
          if(state is Registro){
            return PhoneGoogle(userRepository: widget._userRepository);
          }
        },
      ),
    )
  );
  }
}