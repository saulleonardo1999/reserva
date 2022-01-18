import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:newapp366/DatosEstablecimientos/ReservacionState.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/inicio/inicio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';



class Promo extends StatelessWidget {
  final String usuario;
  final String establecimiento;
  final String imagen;
  final InicioState inicio;
  GeoPoint localizacion;
  DateTime fecha=DateTime.now();
  var hora = DateFormat('H');
  var minuto = DateFormat('m');
  var dia = DateFormat('d');
  var mes = DateFormat('M');
  var aa = DateFormat('y');
  

  Promo({Key key,@required this.usuario,@required this.establecimiento,@required this.imagen,@required this.inicio,this.localizacion}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Usuarios").where("Correo",isEqualTo: usuario).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Container(child: Center(child: Text("Error"),),);
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return Creando(imagen: this.imagen,);
          default:
            FirebaseFirestore.instance.collection("Reservaciones").where("Usuario",isEqualTo: snapshot.data.docs.first.id).get().then((value){
              var date = DateTime.fromMillisecondsSinceEpoch(value.docs.first.data()["Hora y fecha"].millisecondsSinceEpoch);
              if(int.parse(aa.format(fecha))>int.parse(aa.format(date)))
                if(int.parse(hora.format(fecha))==3)
                  if(int.parse(minuto.format(fecha))<=1){
                    
                  }
            });
            bool reservacion;
            String idusuario;
            snapshot.data.docs.forEach((doc) {
              reservacion=doc.data()["Reservacion"];
              idusuario=doc.id;
            });
            print(idusuario);
            return Stack(children: <Widget>[
              Promocion(verifica: reservacion, usuario: idusuario ,establecimiento: this.establecimiento,imagen: this.imagen,inicio: inicio,localizacion: localizacion,),
            ],);
        }
    });
  }
}

class Promocion extends StatefulWidget {
  bool verifica;
  String usuario;
  String establecimiento;
  String imagen;
  final InicioState inicio;
  GeoPoint localizacion;

  Promocion({Key key,@required this.verifica,@required this.usuario,@required this.establecimiento,@required this.imagen,@required this.inicio,this.localizacion}):
  super(key:key);
  @override
  _PromocionState createState() => _PromocionState();
}

class _PromocionState extends State<Promocion> with SingleTickerProviderStateMixin{
  bool get verifica=>widget.verifica;
  String get usuario => widget.usuario; 
  String get establecimiento => widget.establecimiento;
  String get imagen => widget.imagen;
  AnimationController control;
  bool onTab=false;
  InicioState get inicio => widget.inicio;
  GeoPoint get localizacion => widget.localizacion;
  int index=0;
  bool comments=false;

  bool scroll=true;

  @override
  void initState() {
    // TODO: implement initState
    print(verifica); 
    super.initState();
    control=AnimationController(vsync: this,duration: Duration(seconds: 1));
    if(this.verifica==true)
      control.forward();
    else
      control.reverse();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    control?.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        menu(context),
        /*SizedBox.expand(
          child: DraggableScrollableSheet(
            expand: true,
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.75,
            builder: (BuildContext context,s){
              return Comentarios(idUsuario: usuario,idEstablecimiento: establecimiento,s: s,);
            },
          )
        )*/
      ],
    );
  }
  
  Widget menu(BuildContext context) {
    print(localizacion);
    return Scaffold(
      appBar: AppBar(
        title: Text("Promocion"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Container(
            width: 165,
              child: Row(
              children: <Widget>[
                
              Container(
                width: 75,
                child: FlatButton(onPressed: verifica==false?(){return showDialog(context: context,builder: (context){
                return CupertinoAlertDialog(
                    content: Padding(padding: EdgeInsets.only(top:30,bottom: 30),
                      child: Text("Porfavor crea una reservacion"),
                    ),
                    title: Text("Sin resrevacion"),
                    actions: <Widget>[
                      FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Aceptar"))
                    ],
                );
            });}:(){
                inicio.setUbucacion(localizacion);
                inicio.cambiarPagina(2);
                Navigator.of(context).pop();
            },child: Icon(Icons.location_on,color: Colors.white,),padding: EdgeInsets.only(left:60,)),
              ),
            
              FlatButton(onPressed: (){
               return showDialog(context: context,builder: (context){
                 return ReservacionState(context: context,estado: verifica,idusuario: usuario,establecimiento: establecimiento,control: control,);
               }
               );
            },
            child: AnimatedIcon(icon: AnimatedIcons.add_event, progress: control,color: Colors.white,),padding: EdgeInsets.only(left: 20))
              ],
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
          )
        ],
        
      ),
      body: GestureDetector(
        onTap: (){
          if(comments)setState(() {
            comments=false;
          });
        },
              child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(imagen),fit: BoxFit.fill),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Carousel(idEstablecimiento: establecimiento,),
            )
          ],
        ),
      ),
    );


  }
  void onScroll(){
    setState(() {
      scroll=false;
    });
  }
  void onTabChange(){
    print("presione");
    setState(() {
      onTab=true;
    });
  }
}
class Carousel extends StatelessWidget {
  String idEstablecimiento;

  Carousel({Key key,@required this.idEstablecimiento}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Promociones").where("Establecimiento",isEqualTo: idEstablecimiento).snapshots(),builder: (context,snapshot){
      if(snapshot.hasError){
        throw UnimplementedError("Carrousel error");
      }
      switch(snapshot.connectionState){
        case ConnectionState.waiting:
          return Container(
              height: 700,
              child: Center(child: Card(child: CircularProgressIndicator(),))
          );
          default:
            List<DocumentSnapshot> doc=snapshot.data.docs;
            print(doc.toString());
            return (doc.toString()!="[]")? CarouselSlider.builder(itemCount: doc.length, itemBuilder: (context,index,realIndx){
              return Container(decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(doc[index].data()["Promociones"]))),);
            }, options: CarouselOptions(aspectRatio: 2.0,enlargeCenterPage: true,height: 550,autoPlay: true,autoPlayInterval: Duration(seconds: 15))):
            Container(child: Center(child: Text("Sin promociones")),height: 550,);
      }
    });
  }
}
class Creando extends StatelessWidget {
  final String imagen;
  Creando({Key key,@required this.imagen}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Promocion"),
        backgroundColor: Colors.black,
        
      ),
      body: GestureDetector(
              child: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(imagen),fit: BoxFit.fill),
              ),
            ),

            Padding(padding: const EdgeInsets.only(top:200),
              child: Buffer(),
            )
          ],
        ),
      ),
    );
  }
}