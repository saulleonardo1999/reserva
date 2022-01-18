import 'package:flutter/material.dart';

class Acerca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acerca de la empresa"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: SingleChildScrollView(
                  child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                      child: Text("Reserva",style: TextStyle(fontSize: 29,fontStyle: FontStyle.italic)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child: Text("Somos una empresa de Dessarrollo de aplicacoines %100 Méxicana que creó una aplicacion para invoar la forma en la que reservamos de fomra cotidiana.",style: TextStyle(fontSize: 17)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child: Text("La filosofia de Reserva es que siempre encuentres el lugar indicado para ti y que te agrade lo mejor posible, contando con ubicacion para que encuentres los lugares mas cercanos a ti, contamos con apartado por categorias que ayudan a la eleccion del establecimiento de diferentes ramas, contamos con calificacion y comentarios en los establecimientos para que puedas elegir el mejor de ellos, contamos con un buscador que ayuda a buscar tu establecimineto favorito en segundos y posibilidad de escanear tu menu sin necesidad de tenerlo en mano.",style: TextStyle(fontSize: 17),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  child: Text("Asi que ya sabes si quieres en contrar tu lugar ideal en un solo boton y reservar sin necesidad de hablar por telefono y sin molestias, entonces reserva es para ti",style: TextStyle(fontSize: 17)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  child: Text("Rereva con Reserva.",style: TextStyle(fontSize: 19)),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}