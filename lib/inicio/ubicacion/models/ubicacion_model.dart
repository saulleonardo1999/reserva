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
    this.apellidos,
    this.aprobado,
    this.categoria,
    this.nombre,
    this.correo,
    this.coordenadas,
    this.fieldsNombre,
  });

  Apellidos apellidos;
  Aprobado aprobado;
  Apellidos categoria;
  Apellidos nombre;
  Apellidos correo;
  Coordenadas coordenadas;
  Apellidos fieldsNombre;

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    apellidos: Apellidos.fromJson(json["Apellidos"]),
    aprobado: Aprobado.fromJson(json["Aprobado"]),
    categoria: Apellidos.fromJson(json["Categoria"]),
    nombre: Apellidos.fromJson(json["Nombre"]),
    correo: Apellidos.fromJson(json["Correo"]),
    coordenadas: Coordenadas.fromJson(json["coordenadas"]),
    fieldsNombre: Apellidos.fromJson(json["nombre"]),
  );

  Map<String, dynamic> toJson() => {
    "Apellidos": apellidos.toJson(),
    "Aprobado": aprobado.toJson(),
    "Categoria": categoria.toJson(),
    "Nombre": nombre.toJson(),
    "Correo": correo.toJson(),
    "coordenadas": coordenadas.toJson(),
    "nombre": fieldsNombre.toJson(),
  };
}

class Apellidos {
  Apellidos({
    this.stringValue,
  });

  String stringValue;

  factory Apellidos.fromJson(Map<String, dynamic> json) => Apellidos(
    stringValue: json["stringValue"],
  );

  Map<String, dynamic> toJson() => {
    "stringValue": stringValue,
  };
}

class Aprobado {
  Aprobado({
    this.booleanValue,
  });

  bool booleanValue;

  factory Aprobado.fromJson(Map<String, dynamic> json) => Aprobado(
    booleanValue: json["booleanValue"],
  );

  Map<String, dynamic> toJson() => {
    "booleanValue": booleanValue,
  };
}

class Coordenadas {
  Coordenadas({
    this.geoPointValue,
  });

  GeoPointValue geoPointValue;

  factory Coordenadas.fromJson(Map<String, dynamic> json) => Coordenadas(
    geoPointValue: GeoPointValue.fromJson(json["geoPointValue"]),
  );

  Map<String, dynamic> toJson() => {
    "geoPointValue": geoPointValue.toJson(),
  };
}

class GeoPointValue {
  GeoPointValue({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory GeoPointValue.fromJson(Map<String, dynamic> json) => GeoPointValue(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}
