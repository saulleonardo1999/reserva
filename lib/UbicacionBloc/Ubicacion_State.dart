import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class UbicacionState extends Equatable{
  const UbicacionState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SinReservacion extends UbicacionState{
  @override
  // TODO: implement props
  List<Object> get props => ["Sin reservacion"];
}

class ConResrevacion extends UbicacionState{
  @override
  GeoPoint ubicacion;
  // TODO: implement props
  List<Object> get props => [ubicacion];
}

class SinUbicacoin extends UbicacionState{
  GeoPoint ubicacion;
  @override
  // TODO: implement props
  List<Object> get props => [ubicacion];
}

class ConUbicacionActual extends UbicacionState{
  GeoPoint ubicacion;
  @override
  // TODO: implement props
  List<Object> get props => [ubicacion];
}