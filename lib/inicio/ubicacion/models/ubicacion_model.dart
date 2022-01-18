// To parse this JSON data, do
//
//     final ubicacion = ubicacionFromJson(jsonString);

import 'dart:convert';

Ubicacion ubicacionFromJson(String str) => Ubicacion.fromJson(json.decode(str));

String ubicacionToJson(Ubicacion data) => json.encode(data.toJson());

class Ubicacion {
  Ubicacion({
    this.name,
    this.fields,
    this.createTime,
    this.updateTime,
  });

  String name;
  Fields fields;
  DateTime createTime;
  DateTime updateTime;

  factory Ubicacion.fromJson(Map<String, dynamic> json) => Ubicacion(
    name: json["name"],
    fields: Fields.fromJson(json["fields"]),
    createTime: DateTime.parse(json["createTime"]),
    updateTime: DateTime.parse(json["updateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "fields": fields.toJson(),
    "createTime": createTime.toIso8601String(),
    "updateTime": updateTime.toIso8601String(),
  };
}

class Fields {
  Fields({
    this.longitud,
    this.nombre,
    this.latitud,
    this.img,
  });

  StringValue longitud;
  StringValue nombre;
  StringValue latitud;
  StringValue img;

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    longitud: StringValue.fromJson(json["longitud"]),
    nombre: StringValue.fromJson(json["nombre"]),
    latitud: StringValue.fromJson(json["latitud"]),
    img: StringValue.fromJson(json["img"]),
  );

  Map<String, dynamic> toJson() => {
    "longitud": longitud.toJson(),
    "nombre": nombre.toJson(),
    "latitud": latitud.toJson(),
    "img": img.toJson(),
  };
}

class StringValue {
  StringValue({
    this.stringValue,
  });

  String stringValue;

  factory StringValue.fromJson(Map<String, dynamic> json) => StringValue(
    stringValue: json["stringValue"],
  );

  Map<String, dynamic> toJson() => {
    "stringValue": stringValue,
  };
}
