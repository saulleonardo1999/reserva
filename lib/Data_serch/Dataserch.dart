import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newapp366/inicio/inicio.dart';
import 'package:newapp366/Data_serch/promociones.dart';




class Datasearch extends SearchDelegate<String>{
  List<DocumentSnapshot> doc;
  InicioState inicio;
  String usuario;

  Datasearch({@required this.doc,@required this.inicio,@required this.usuario});

  int selection=0;
  String establecimiento;
  String image;

  @override
  List<Widget> buildActions(BuildContext context) {
      return [IconButton(onPressed: (){
        query="";
        showSuggestions(context);
      },icon: Icon(Icons.clear),),
      ];
    }
  
    @override
    Widget buildLeading(BuildContext context) {
      return IconButton(icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), onPressed: (){
              close(context, null);
            });
    }
  
    @override
    Widget buildResults(BuildContext context) {
      if(query.isEmpty)
        selection=-1;
      else
      return Promo(usuario: usuario, establecimiento: establecimiento, imagen: image, inicio: inicio);
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
      List datos=[];
      doc.forEach((element) {
        datos.add({"id":element.id,"nombre":element.data()["nombre"],"coordenadas":element.data()["coordenadas"]});
      });
      List suggestionsList = query.isEmpty?datos:datos.where((element) => element["nombre"].startsWith(query)).toList();
      print(suggestionsList);
    // TODO: implement buildSuggestions
    return suggestionsList.isEmpty? Card(child: Text("Sin resultados"),):ListView.builder(itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.fromLTRB(40,20,40,20),
        child: imagen(suggestionsList[index]["id"],index,suggestionsList),
      );
    },itemCount: suggestionsList.length,);
  }
  /*Padding(
        padding: const EdgeInsets.fromLTRB(40,20,40,20),
        child: Row(
          children: [
            imagen(doc[index].id),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(doc[index].data()["nombre"],style: TextStyle(fontSize: 25),),
            )
          ],
        ),
      );*/
  Widget imagen(String id,int index,List suggestionsList){
    return FutureBuilder(future: FirebaseFirestore.instance.collection("Imagenes").doc(id).get(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          throw UnimplementedError("Error imagenes");
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return ListTile(
              title: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(suggestionsList[index]["nombre"],style: TextStyle(fontSize: 25),),
                ),
              leading: Card(
                child: CircularProgressIndicator(),
              ),
              onTap: (){
                query=suggestionsList[index]["nombre"];
                establecimiento=suggestionsList[index]["id"];
                image=snapshot.data.data()["ImagenURL"].toString();
                showResults(context);
              },
            );
          default:
          try {
            snapshot.data.data()["ImagenURL"].toString();
            return ListTile(
              title: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(suggestionsList[index]["nombre"],style: TextStyle(fontSize: 25),),
                ),
              leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data.data()["ImagenURL"].toString()),),
              onTap: (){
                query=suggestionsList[index]["nombre"];
                establecimiento=suggestionsList[index]["id"];
                image=snapshot.data.data()["ImagenURL"].toString();
                showResults(context);
              },
            );
            
          } catch (e) {
            return ListTile(
              title: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Text(suggestionsList[index]["nombre"],style: TextStyle(fontSize: 25),),
                ),
              leading: CircleAvatar(child: Icon(Icons.person),backgroundColor: Colors.black,),
              onTap: (){
                query=suggestionsList[index]["nombre"];
                establecimiento=suggestionsList[index]["id"];
                image=snapshot.data.data()["ImagenURL"].toString();
                showResults(context);
              },
            );
          }
        }
      }
    );
  }
}


