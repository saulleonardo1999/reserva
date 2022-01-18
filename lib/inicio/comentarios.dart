import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Comentarios extends StatefulWidget {
  bool isCollapsed=false;
  String idEstablecimiento;
  String idUsuario;
  ScrollController s;
  
  Comentarios({Key key,@required this.idEstablecimiento,@required this.idUsuario,@required this.s}):super(key:key);
  @override
  _ComentariosState createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  double screenHeight,screenWidth; 
  bool get isCollapsed=>widget.isCollapsed;
  Stream<QuerySnapshot> stream;
  TextEditingController control;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    stream=FirebaseFirestore.instance.collection("Establecimientos").doc(widget.idEstablecimiento).collection("Calificacion").snapshots();
    control=TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight=size.height;
    screenWidth=size.width;
  print("Cargo");

    return Container(
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        child: StreamBuilder(stream: stream,builder: (context,snapshot){
          if(snapshot.hasError){
            throw UnimplementedError("Sin comentarios");
          }
          switch(snapshot.connectionState){
            
            case ConnectionState.waiting:
              return Container(decoration: BoxDecoration(color: Colors.white),child: Center(
                child: Card(child: CircularProgressIndicator(),),
              ),);
            default:
              List<DocumentSnapshot> doc=snapshot.data.docs;
                print(doc.toString());
                return (doc.toString()=="[]")?comentariosNull(context, "null", doc):coments(context, "coments", doc);
          }
        },)
      
    );
  }

  Widget coments(BuildContext context,String signal,List<DocumentSnapshot> comentarios){
    print(comentarios[0].id);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(20))),
      child: Scaffold(
          backgroundColor: Colors.transparent,
            body: ListView(
              controller: widget.s,
              children: [
                Padding(padding: EdgeInsets.only(bottom:20,),child: Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                ),),
                Padding(
                  padding: const EdgeInsets.only(left: 15,bottom: 15),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 60),
                          child: Icon(Icons.comment),
                        ),
                        Text("Comentarios",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20,right: 15,left: 15),
                  child: Container(
                    decoration: BoxDecoration(
                    ),
                    height: 380,
                    child: ListView.builder(itemCount: comentarios.length,itemBuilder: (context,index){
                    return Container(child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:20),
                              child: Usuario(idUsuario: comentarios[index].id,)
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10),
                              child: Container(
                                child: Text(comentarios[index].data()["Comentario"]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
                  }),
                  ),
                ),
                Container(
                  child: Row(children: [
                  SizedBox(
                    width: 310,
                    child: Padding(padding: EdgeInsets.only(left: 10),child: TextField(controller: control,
                      decoration: InputDecoration(border: new OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                fillColor: Colors.white,
                filled: true,
                hintText: "Comentario",),
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: IconButton(iconSize: 29,icon: Icon(Icons.send,color: Colors.blueAccent,),onPressed: (){
                      if(control.text==""){
                        print("No hace nada");
                      }else{
                        FirebaseFirestore.instance.collection("Establecimientos").doc(widget.idEstablecimiento).collection("Calificacion").doc(widget.idUsuario).set({"Comentario":control.text});
                        control.clear();
                      }
                    },),
                  )
                ],),
                )
              ],
            ),
      ),
    );
  }
  Widget comentariosNull(BuildContext context,String signal,List<DocumentSnapshot> comentarios){
    return Material(
      color: Colors.transparent,
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),color: Colors.white),child: SingleChildScrollView(
            controller: widget.s,
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:30),
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15,bottom: 15,top: 20),
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 60),
                          child: Icon(Icons.comment),
                        ),
                        Text("Comentarios",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:180,bottom: 180),
                  child: Center(child: Text("Sin comentarios"),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    child: Row(children: [
                      SizedBox(
                        width: 310,
                        child: Padding(padding: EdgeInsets.only(left:10),child: TextField(controller: control,
                          decoration: InputDecoration(border: new OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Comentario",),
                        ),),
                      ),
                      IconButton(iconSize: 29,icon: Icon(Icons.send,color: Colors.blueAccent,),onPressed: (){
                          if(control.text==""){
                            print("no hace nada");
                          }else{
                            FirebaseFirestore.instance.collection("Establecimientos").doc(widget.idEstablecimiento).collection("Calificacion").doc(widget.idUsuario).set({"Comentario":control.text});
                            control.clear();
                          }
                      },)
                    ],),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
class Usuario extends StatelessWidget {
  String idUsuario;

  Usuario({Key key,@required this.idUsuario}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Usuarios").doc(idUsuario).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          throw UnimplementedError("No se que pedo");
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Container(child: Center(child:  CircularProgressIndicator(),),);
          default:
            return design(context,snapshot.data.data()["Nombre"]);
        }
      },
    );
  }
  Widget design(BuildContext context,String nombre){
    return Row(children: [
                          CircleAvatar(backgroundColor: Colors.black,child: Icon(Icons.face,color: Colors.white,),),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(nombre),
                          )
                        ],);
  }
}