import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/Principal/registro.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
abstract class AuthenticationState extends Equatable{
  const AuthenticationState();
  List<Object>get props=>[];
}

//no inicializado

class Unitialized extends AuthenticationState{
  @override
  String toString() =>'No inicializado';
}
//autenticado

class Authenicated extends AuthenticationState{
  final String displayName;
  final String imagen;
  
  const Authenicated(this.displayName,this.imagen);

  List<Object>get props=>[displayName,imagen];

  @override
  String toString() =>'Autenticado -> Nombre $displayName--$imagen';
}
//no autenticado

class Unauthenticated extends AuthenticationState{
  @override
  String toString()=>'No Autenticado';
}
class Registro extends AuthenticationState{
  @override
  String toString() => 'Alta';
}