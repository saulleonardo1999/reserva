import 'package:flutter/material.dart';

class Soporte extends StatefulWidget {
  @override
  _SoporteState createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  String mensaje="";
  TextEditingController mss=TextEditingController();
  List<Map<String,dynamic>> messages =[
    {"n1":"Hola"},
    {"n1":"Buenas tardes"},
    {"n2":"Que tal"},
  ];
  @override
  Widget build(BuildContext context) {
    print(messages[2].keys.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
              child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
              child: Container(
                height: 570,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                width: double.infinity,
                child: ListView.builder(itemBuilder: (context,index){
                  String corregido = messages[index].values.toString().replaceAll("(", "");
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: (messages[index].keys.toString()=="(n1)")?MainAxisAlignment.end:MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 60,
                              width: 150,
                              decoration: BoxDecoration(image: DecorationImage(image: (messages[index].keys.toString()=="(n1)")?AssetImage("assets/images/chat-7.png"):AssetImage("assets/images/chat-17.png"),fit: BoxFit.fill)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:10,left: 8),
                              child: Text(corregido.replaceAll(")", "")),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },itemCount: messages.length,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 10),
              child: Row(
                children: [
                  SizedBox(width: 280,child: TextField(controller: mss,onChanged: (txt){this.mensaje=txt;},decoration: InputDecoration(hintText: "Mensaje",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),)),
                  IconButton(icon: Icon(Icons.send,color: Colors.blue,), onPressed: (){
                    setState(() {
                      if(this.mensaje=="") print("null");
                      else{
                        messages.add({"n1":mensaje});
                        this.mss.clear();
                      }
                    });
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}