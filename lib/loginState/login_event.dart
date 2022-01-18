import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//email changed
class EmailChanged extends LoginEvent{
  final String email;

  EmailChanged({@required this.email});

  List<Object> get props => [email];
}
//password changed
class PasswordChanged extends LoginEvent{
  final String password;

  PasswordChanged({@required this.password});

  List<Object> get props => [password];
}
//is submitting
class Cargando extends LoginEvent{
  final String email;
  final String password;
  Cargando({@required this.email,@required this.password});

  List<Object> get props => [email,password];
}
//login pressed
class LoginEandP extends LoginEvent{
  final String email;
  final String password;
  LoginEandP({@required this.email,@required this.password});

  List<Object> get props => [email,password];
}
//loginwhitgooglepresed
class LoginWithGoogle extends LoginEvent{}