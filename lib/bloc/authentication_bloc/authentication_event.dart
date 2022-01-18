import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:newapp366/src/repository/users_repository.dart';

class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();

  @override
  List<Object>get props=>[];
}
 //AppStarted

 class AppStarted extends AuthenticationEvent{}
 //LoggedIn
 class LoggedIn extends AuthenticationEvent{}
 //LogedOut
 class LoggedOut extends AuthenticationEvent{}
 //LoginWithGoogle
 class LoggedInGoolge extends AuthenticationEvent{
   UserRepository userRepository;
   String numero;
   LoggedInGoolge({@required this.userRepository,@required this.numero});
 }
 class Ready extends AuthenticationEvent{}