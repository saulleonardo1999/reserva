import 'package:flutter/material.dart';

class RegistroState{
  final bool isPasswordValid;
  final bool isEmailValid;
  final bool isFailature;
  final bool isSuccess;
  final bool submiting;

  RegistroState({@required this.isPasswordValid,@required this.isEmailValid,@required this.isFailature,
  @required this.isSuccess,@required this.submiting});

  bool get isFormValid=> isEmailValid && isPasswordValid;


  factory RegistroState.empty(){
    return RegistroState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSuccess: false,
      submiting: false
    );
  }
  factory RegistroState.success(){
    return RegistroState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSuccess: true,
      submiting: false
    );
  }
  factory RegistroState.failature(){
    return RegistroState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: true,
      isSuccess: false,
      submiting: false
    );
  }
  factory RegistroState.loading(){
    return RegistroState(
      isEmailValid: true,
      isPasswordValid: true,
      isFailature: false,
      isSuccess: false,
      submiting: true
    );
  }
  RegistroState copyWhit({
    bool isEmailValid,
    bool isPasswordValid,
    bool isFailature,
    bool isSuccess,
    bool submiting,
  }){return RegistroState(isEmailValid: isEmailValid??this.isEmailValid,isPasswordValid: isPasswordValid??this.isPasswordValid,
  isFailature: isFailature??this.isFailature,isSuccess: isSuccess??this.isSuccess,submiting: submiting??this.submiting);}

  RegistroState update({bool isEmailValid,bool isPasswordValid}){
    return copyWhit(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSuccess: false,
      isFailature: false,
      submiting: false,
    );
  }
}