import 'package:rxdart/rxdart.dart';
import 'package:newapp366/registerState/register_event.dart';
import 'package:newapp366/registerState/register_state.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:newapp366/src/repository/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/util/validators.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroBloc extends Bloc<RegistroEvent, RegistroState> {
  UserRepository _userRepository;

  RegistroBloc({@required UserRepository userRepository}):
  assert (userRepository!=null),
  _userRepository=userRepository, super(RegistroState.empty());

  @override
  Stream<Transition<RegistroEvent, RegistroState>> transformEvents(Stream<RegistroEvent> events, transitionFn) {
    final nonDobounceStream=events.where((event){
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream=events.where((event){
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));

    return super.transformEvents(nonDobounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<RegistroState> mapEventToState(
    RegistroEvent event,
  ) async* {
    if(event is RegistroClick){
      yield* _mapRegistroClicktoState(
        email: event.email,
        password: event.password,
        nombre: event.nombre,
        apellidos: event.apellidos,
        numero: event.numero
      );
    }
    if(event is EmailChanged){
      yield* _mapEmailChangedtoState(event.email);
    }
    if(event is PasswordChanged){
      yield* _mapPasswordChangedtoState(event.password);
    }
  }
  Stream<RegistroState>_mapRegistroClicktoState({String email,String password,String nombre,String apellidos,String numero})async*{
    print(numero);
    yield RegistroState.loading();
    try{
      await _userRepository.signUp(email, password);
      await FirebaseFirestore.instance.collection("Usuarios").doc().set({'Nombre':nombre+' '+apellidos,'Correo':email,'Numero':numero,'Reservacion':false, 'Notificaciones':true, 'Nivel':0, 'Xp':0.1});
      yield RegistroState.success();
    }catch(_){
      yield RegistroState.failature();
    }
  }
  Stream<RegistroState>_mapEmailChangedtoState(String email) async*{
    yield state.update(
      isEmailValid: Vlaidators.isValidEmail(email)
    );
  }
  Stream<RegistroState>_mapPasswordChangedtoState(String password) async*{
    yield state.update(
      isPasswordValid: Vlaidators.isPasswordValid(password)
    );
  }
}