import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_state.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
    : assert(userRepository!=null),
    _userRepository=userRepository, super(Unitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is AppStarted){
      yield* _mappStartedToState();
    }
    if(event is LoggedIn){
      yield* _mappLogedInToState();
    }
    if(event is LoggedOut){
      yield* _mappLoggedOutToState();
    }
    if(event is LoggedInGoolge){
      yield* _mappLogedInGoogleToState(event.userRepository,event.numero);
    }
    if(event is Ready){
      yield* _mapReadyToState();
    }
  }
  Stream<AuthenticationState> _mappStartedToState() async*{
    yield Unitialized();
    try{
      if(await _userRepository.isSignedIn()==null){
        yield Unauthenticated();
      }
      if(await _userRepository.isSignedIn()){
        QuerySnapshot doc = await FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: await _userRepository.getEmail()).get();
        if(doc.docs.toString()=="[]"){
          yield Unauthenticated();
        }else{
          yield Authenicated(await _userRepository.getEmail(),await _userRepository.getPic());
        }
      }else{
        yield Unauthenticated();
      }
    }catch(_){
      yield Unauthenticated();
    }
  }
  Stream<AuthenticationState>_mappLogedInToState() async*{
    try{
      if(_userRepository.getPic().toString()=="null")
        yield Authenicated(await _userRepository.getEmail(),"[]");
      else{
        QuerySnapshot doc = await FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: await _userRepository.getEmail()).get();
        if(doc.docs.toString()=="[]"){
          print("consulta");
          yield Registro();
        }else{
          yield Authenicated(await _userRepository.getEmail(),await _userRepository.getPic());
        }
      }
    }catch(_){
      print("Catch");
      yield Authenicated("manitote@gmail.com","https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngwing.com%2Fes%2Fsearch%3Fq%3Dmarca%2Bx&psig=AOvVaw3y-fW8VLvk-lTPJXF5hXx2&ust=1641345907838000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOjl9ZD4lvUCFQAAAAAdAAAAABAI");
    }
  }
  Stream<AuthenticationState>_mappLoggedOutToState() async*{
    _userRepository.singOut();
    yield Unauthenticated();
  }
  Stream<AuthenticationState>_mappLogedInGoogleToState(UserRepository userRepository,String numero) async*{
    //String verifica;
    yield Unitialized();
    final user=await _userRepository.singnInWithGoogle();
    //await FirebaseFirestore.instance.collection("Usuarios").where("Numero", isEqualTo: correo).get().then((snapshot){verifica=snapshot.docs.toString();});
    if(user!=null){
      await FirebaseFirestore.instance.collection("Usuarios").doc().set({'Nombre':await userRepository.getUser(),'Correo':await userRepository.getEmail(),'Numero':numero,'Reservacion':false, 'Notificaciones':true , 'Nivel':0 ,'Xp':0.1});
      yield Authenicated(await _userRepository.getEmail(), await _userRepository.getPic());
    }else{
      yield Unauthenticated();
    }
  }
  Stream<AuthenticationState>_mapReadyToState() async*{
    yield Unitialized();
    final user=await _userRepository.singnInWithGoogle();
    if(user!=null){
      yield Authenicated(await _userRepository.getEmail(), await _userRepository.getPic());
    }else{
      yield Unauthenticated();
    }
  }
}