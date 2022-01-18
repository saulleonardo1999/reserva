import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

abstract class RegistroEvent extends Equatable{
  const RegistroEvent();

  @override
  List<Object> get props => [];
}
class EmailChanged extends RegistroEvent{
  final String email;
  EmailChanged({@required this.email});

  @override
  // TODO: implement props
  List<Object> get props => [email];
}
class PasswordChanged extends RegistroEvent{
  final String password;
  PasswordChanged({@required this.password});

  @override
  // TODO: implement props
  List<Object> get props => [password];
}
class RegistroClick extends RegistroEvent{
  final String email;
  final String password;
  final String nombre;
  final String apellidos;
  final String numero;

  RegistroClick({@required this.email,@required this.password,@required this.nombre,@required this.apellidos,@required this.numero});

  @override
  // TODO: implement props
  List<Object> get props => [email,password,nombre,apellidos];
}
class Loading extends RegistroEvent{}
