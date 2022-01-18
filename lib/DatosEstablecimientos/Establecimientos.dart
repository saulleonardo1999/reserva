import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newapp366/inicio/inicio.dart';
import 'package:newapp366/inicio/promociones.dart';
import 'package:animations/animations.dart';

class Establecimientos extends StatefulWidget {

  final String idusuario;
  final InicioState inicio;
  final List<DocumentSnapshot> doc;

  Establecimientos({Key key,@required this.idusuario,@required this.inicio,@required this.doc}):super(key:key);

  _EstablecimientosState createState() => _EstablecimientosState();
}

class _EstablecimientosState extends State<Establecimientos> with SingleTickerProviderStateMixin {

  String get idusuario=> widget.idusuario;

  AnimationController control;
  String imagen;
  InicioState get inicio => widget.inicio;
  List<DocumentSnapshot> get doc => widget.doc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    control?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context,index){
      return Imagen(context: context,id: doc[index].id,idusuario: idusuario,inicio: inicio,localizacion: doc[index].data()["coordenadas"],);
    },itemCount: doc.length,);
  }
  void cmabio(){
    setState(() {
      
    });
  }
}
class Imagen extends StatelessWidget {
  final String id;
  final String idusuario;
  final BuildContext context;
  final InicioState inicio;
  final GeoPoint localizacion;

  Imagen({Key key,@required this.context,@required this.id,@required this.idusuario,@required this.inicio,@required this.localizacion}):super(key:key);
  @override
  Widget build(context) {
    return FutureBuilder(future: FirebaseFirestore.instance.collection("Imagenes").doc(id).get(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return establecimientosBlanco(context);
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return establecimientosBlanco(context);
          default:
          try {
            snapshot.data.data()["ImagenURL"].toString();
            return establecimientos(context, id, snapshot.data.data()["ImagenURL"].toString(),inicio,localizacion);
          } catch (e) {
            return establecimientos(context, id, "[]",inicio,localizacion);
          }
        }
      }
    );
  }
  establecimientos(BuildContext context,String id,String imagen,InicioState inicio,GeoPoint localizacion){
    return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Promo(establecimiento: id,usuario: this.idusuario,imagen: imagen,inicio: inicio,localizacion: localizacion,)));
                },
                child: Container(
                height: 250,
                decoration: imagen=="[]"?BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/stopwatch.png"),fit: BoxFit.cover)):
                BoxDecoration(image: DecorationImage(image: NetworkImage(imagen),fit: BoxFit.fill)),
            ),
              );/*OpenContainer(
              transitionDuration: Duration(milliseconds: 600),openBuilder: (context,_)=>Promo(establecimiento: id,usuario: this.idusuario,imagen: imagen,inicio: inicio,localizacion: localizacion,),
              closedBuilder: (context,VoidCallback openContainer)=>*/
  }
  establecimientosBlanco(BuildContext context){
    return Container(
        color: Colors.white,
        height: 250,
      );
          /*child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Promo(establecimiento: id,usuario: this.idusuario)));
                    },
                    child: Text("Ver Promociones",style: TextStyle(color: Colors.deepOrange),),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(color: Colors.deepOrange)),
                    )
                ],
              )
            ],
          )
        );*/
  }
}
/*class Rating extends StatelessWidget {
  String idEstablecimiento;
  
  Rating({Key key,@required this.idEstablecimiento}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: FirebaseFirestore.instance.collection("Establecimientos").doc(idEstablecimiento).collection("Calificacion").get(),builder: (context,snapshot){
      if(snapshot.hasError){
        throw Text("Sin datos");
      }
      switch(snapshot.connectionState){
        case ConnectionState.waiting:
          return RatingBar(ratingWidget: RatingWidget(full: Icon(Icons.star_rounded,color:Colors.lightGreen,size: 4,), half: Icon(Icons.star_half_rounded,color:Colors.lightGreen,size: 4,), empty: Icon(Icons.star_border_rounded,color:Colors.lightGreen,size: 4,)), onRatingUpdate: null,
              initialRating: 0,
              direction: Axis.horizontal,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              allowHalfRating: false,
              itemCount: 5,  
              itemSize: 24,     
            );
        default:
          try{
            List<DocumentSnapshot> doc = snapshot.data.docs;
            double total=0;
            print(snapshot.toString());
            doc.forEach((element) {total+=element.data()["Estrellas"];});
            if(doc.length==0)total=0;
            else total/=doc.length;
            print(total);
            return RatingBar(ratingWidget: RatingWidget(full: Icon(Icons.star_rounded,color:Colors.lightGreen,size: 4,), half: Icon(Icons.star_half_rounded,color:Colors.lightGreen,size: 4,), empty: Icon(Icons.star_border_rounded,color:Colors.lightGreen,size: 4,)), onRatingUpdate: null,
              initialRating: total,
              direction: Axis.horizontal,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              allowHalfRating: false,
              itemCount: 5,  
              itemSize: 24,     
            );
          }catch(_){
            return RatingBar(ratingWidget: RatingWidget(full: Icon(Icons.star_rounded,color:Colors.lightGreen,size: 4,), half: Icon(Icons.star_half_rounded,color:Colors.lightGreen,size: 4,), empty: Icon(Icons.star_border_rounded,color:Colors.lightGreen,size: 4,)), onRatingUpdate: null,
              initialRating: 0,
              direction: Axis.horizontal,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              allowHalfRating: false,
              itemCount: 5,  
              itemSize: 24,     
            );
          }
      }
    });
  }
}*/
class Establecimiento extends StatelessWidget {
  final String id;
  final String idusuario;
  final String imagen;
  final InicioState inicio;
  final GeoPoint localizacion;

  Establecimiento({Key key,@required this.id,@required this.idusuario,@required this.imagen,@required this.inicio,@required this.localizacion}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
            transitionDuration: Duration(milliseconds: 800),openBuilder: (context,_)=>Promo(establecimiento: id,usuario: this.idusuario,imagen: imagen,inicio: inicio,localizacion: localizacion,),
            closedBuilder: (context,VoidCallback openContainer)=>GestureDetector(
              onTap: openContainer,
              child: Container(
              decoration: imagen=="[]"?BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/stopwatch.png"),fit: BoxFit.cover)):
              BoxDecoration(image: DecorationImage(image: NetworkImage(imagen),fit: BoxFit.fill)),
          ),
            ),
    );
  }
}