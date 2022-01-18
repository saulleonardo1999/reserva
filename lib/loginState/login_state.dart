import 'package:flutter/material.dart';
import 'package:newapp366/Principal/logeo.dart';
import 'package:newapp366/src/repository/users_repository.dart';

class LoginState with ChangeNotifier{
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailature;
  final bool isSuccessGoogle;

  bool get isFormValid => isEmailValid && isPasswordValid;
  //contructor
  LoginState({@required this.isEmailValid,@required this.isFailature,@required this.isPasswordValid,
  @required this.isSubmitting,@required this.isSuccess,@required this.isSuccessGoogle});
  //vacio
  factory LoginState.empty(){
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSubmitting: false,
      isSuccess: false,
      isSuccessGoogle: false
    );
  }
  //failature
  factory LoginState.failature(){
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: true,
      isSubmitting: false,
      isSuccess: false,
      isSuccessGoogle: false
    );
  }
  //submiting
  factory LoginState.loading(){
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSubmitting: true,
      isSuccess: false,
      isSuccessGoogle: false
    );
  }
  //succes
  factory LoginState.success(){
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSubmitting: false,
      isSuccess: true,
      isSuccessGoogle: false
    );
  }
  //success google
  factory LoginState.successGoogle(){
    return LoginState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSubmitting: false,
      isSuccess: false,
      isSuccessGoogle: true
    );
  }
  //copywith - update
  LoginState copyWhit({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitting,
    bool isFailature,
    bool isSuccess,
    bool isSuccessGoogle
  }){return LoginState(isEmailValid: isEmailValid??this.isEmailValid, isPasswordValid: isPasswordValid??this.isPasswordValid,isFailature: isFailature??this.isFailature,
  isSubmitting: isSubmitting??this.isSubmitting,isSuccess: isSuccess??this.isSuccess,isSuccessGoogle: isSuccessGoogle??this.isSuccessGoogle);}

  LoginState update({
    bool isEmailVlaid,
    bool isPasswordValid
  }){
    return copyWhit(
      isEmailValid: isEmailVlaid,
      isPasswordValid: isPasswordValid,
      isSubmitting: false,
      isSuccess: false,
      isFailature: false,
      isSuccessGoogle: false
    );
  }
}