import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newapp366/Data_serch/Dataserch.dart';
import 'package:newapp366/DatosEstablecimientos/Establecimientos.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:newapp366/bloc/authentication_bloc/authentication_event.dart';
import 'package:newapp366/inicio/inicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp366/Principal/cargando.dart';
import 'package:newapp366/my_icons_icons.dart';



class Serviciosini extends StatefulWidget{

  final String nombre;
  final InicioState inicio;

  Serviciosini({Key key,@required this.nombre,@required this.inicio});

  @override
  _ServiciosiniState createState() => _ServiciosiniState();
}

class _ServiciosiniState extends State<Serviciosini> {
  String title="Inicio";
  List<String> categoria=["Antro","Bar","Restaurant"];
  int index=0;
  ScrollController controller=ScrollController();
  Body body;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: FirebaseFirestore.instance.collection("Establecimientos").get(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  throw UnimplementedError("Sin conexion con los establecimienntos");
                }
                switch(snapshot.connectionState){
                  case ConnectionState.waiting: return Buffer();
                  default:
                    return DefaultTabController(
                        length: 3,
                        initialIndex: index,
                        child: Scaffold(
                          extendBodyBehindAppBar: false,
                          appBar: AppBar(
                            title: Text("Resreva",style: TextStyle(color: Colors.white,fontSize: 24),),
                            backgroundColor: Colors.black,
                            actions: [
                                IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
                                  showSearch(context: context, delegate: Datasearch(doc: snapshot.data.docs,inicio: widget.inicio,usuario: widget.nombre));
                                },),
                              ],
                            bottom: TabBar(
                              indicatorColor: Color(0xFF14C1BC),
                              labelColor: Color(0xFF9E3AAF),
                                    unselectedLabelColor: Colors.white,
                                    tabs: [
                                      Tab(icon: Icon(MyIcons.ice_bucket)),
                                      Tab(icon: Icon(MyIcons.local_bar)),
                                      Tab(icon: Icon(MyIcons.fork)),
                                    ],
                                  ),
                          ),
                          
                        /*appBar: AppBar(backgroundColor: Colors.black,title:Text("Inicio"),leading: IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
                          showSearch(context: context, delegate: Datasearch(doc: snapshot.data.docs,inicio: widget.inicio,usuario: widget.nombre));
                        },),),*/
                        body: TabBarView(
                          children: [
                            Body(inicio: widget.inicio,nombre: widget.nombre,categoria: "Antro",),
                            Body(inicio: widget.inicio,nombre: widget.nombre,categoria: "Bar",),
                            Body(inicio: widget.inicio,nombre: widget.nombre,categoria: "Restaurant",),
                          ],
                        ), 
                        floatingActionButton: FloatingActionButton(onPressed: ()async{
                          try{
                            String menu=await FlutterBarcodeScanner.scanBarcode("#12CAB9", "Cancelar", true, ScanMode.QR);
                            print("Scaneado");
                          }catch(_){
                            print("Error");
                          }
                        },child: Image(image: AssetImage("assets/images/menu.png"),width: 40,height: 40,color: Colors.white,),backgroundColor: Colors.black,),
                      ),
                    );
                }
            });
  }
  /*Widget seleccion(String nombre,String cate,Color color,int seleccion){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text(nombre,style: TextStyle(color: Colors.white),),
          onPressed: (){
            print(categoria);
            setState(() {
              categoria=cate;
              index=seleccion;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12,bottom: 8),
          child: Container(
            width: 25,
            height: 2,
            color: color,
          ),
        )
      ],
    );
  }*/
}
 class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
    _SliverAppBarDelegate(this._tabBar);

    final TabBar _tabBar;

    @override
    double get minExtent => _tabBar.preferredSize.height;
    @override
    double get maxExtent => _tabBar.preferredSize.height;

    @override
    Widget build(
        BuildContext context, double shrinkOffset, bool overlapsContent) {
      return new Container(
        child: _tabBar,
      );
    }

    @override
    bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
      return false;
    }
  }
/*FutureBuilder(future: FirebaseFirestore.instance.collection("Establecimientos").get(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasError){
                throw UnimplementedError("Sin conexion con los establecimienntos");
              }
              switch(snapshot.connectionState){
                case ConnectionState.waiting: return Buffer();
                default:
                  return Scaffold(
                    appBar: AppBar(backgroundColor: Colors.black,title:Text("Inicio"),leading: IconButton(icon: Icon(Icons.search,color: Colors.white,),onPressed: (){
                      showSearch(context: context, delegate: null);
                    },),),
                    body: Establecimientos(idusuario: nombre,inicio: inicio), 
                    floatingActionButton: FloatingActionButton(onPressed: ()async{
                      try{
                        String menu=await FlutterBarcodeScanner.scanBarcode("#12CAB9", "Cancelar", true, ScanMode.QR);
                        print("Scaneado");
                      }catch(_){
                        print("Error");
                      }
                    },child: Icon(Icons.restaurant_menu,color: Colors.white,),backgroundColor: Colors.black,),
                  )
              }
          });*/

class Body extends StatefulWidget {
  String nombre;
  InicioState inicio;
  String categoria;

  Body({@required this.nombre,@required this.inicio,@required this.categoria});
  @override
  BodyState createState() => BodyState();
}

class BodyState extends State<Body> {
  List<String> categoria=["Antro","Bar","Restaurant"];


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: FirebaseFirestore.instance.collection("Establecimientos").where("Categoria",isEqualTo: widget.categoria).get(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  throw UnimplementedError("Sin conexion con los establecimienntos");
                }
                switch(snapshot.connectionState){
                  case ConnectionState.waiting: return Buffer();
                  default:
                    return RefreshIndicator(onRefresh: ()async{
                      setState(() {
                        
                      });
                    },child: Establecimientos(idusuario: widget.nombre,inicio: widget.inicio,doc: snapshot.data.docs,));
                }
            });
  }
  void changeState(){
    setState(() { });
  }
}
class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: 29,
        ),
      ),
    );
  }
}