import 'package:bloc/bloc.dart';
import 'package:newapp366/loginState/login_event.dart';
import 'package:newapp366/loginState/login_state.dart';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/util/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;

  LoginBloc({@required UserRepository userRepository}):
  assert(userRepository!=null),
  _userRepository=userRepository, super(LoginState.empty());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event){
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final isDebounceStream = events.where((event){
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    // TODO: implement transformEvents
    return super.transformEvents(nonDebounceStream.mergeWith([isDebounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is EmailChanged){
      yield* _mapEmailChangedtoState(event.email);
    }
    if(event is PasswordChanged){
      yield* _mapPasswordChangedtoState(event.password);
    }
    if(event is LoginEandP){
      yield* _mapLoginEandPtoState(
        email: event.email,
        password: event.password
      );
    }
    if(event is LoginWithGoogle){
      yield* _mapLoginWithGoogle();
    }
  }
  Stream<LoginState>_mapEmailChangedtoState(String email) async*{
    yield state.update(
      isEmailVlaid: Vlaidators.isValidEmail(email)
    );
  }
  Stream<LoginState>_mapPasswordChangedtoState(String password) async*{
    yield state.update(
      isPasswordValid: Vlaidators.isPasswordValid(password)
    );
  }
  Stream<LoginState>_mapLoginWithGoogle() async*{
    print("Login whit google");
    yield LoginState.loading();
      
    yield LoginState.successGoogle();
  }
  Future<bool> registro(String correo) async{
    String verifica;
    try{
      await FirebaseFirestore.instance.collection("Usuarios").where("Correo", isEqualTo: correo).get().then((snapshot){verifica=snapshot.docs.toString();});
      print(verifica.toString());
    }catch(_){
      print(_);
      //registro(correo);
    }
    if(verifica=="[]"){
      print("Nuevo");
      return false;
    }
    else{
      print("Ya existe");
      return true;
    }
  }
  Stream<LoginState>_mapLoginEandPtoState({String email,String password})async*{
    yield LoginState.loading();
    try{
      //await _userRepository.signInWhitCredentials(email, password);
      yield LoginState.success();
    }catch(_){
      yield LoginState.failature();
    }
  }
}