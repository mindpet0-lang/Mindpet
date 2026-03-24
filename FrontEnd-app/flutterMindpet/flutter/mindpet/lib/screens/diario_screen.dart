import 'package:flutter/material.dart';
import 'package:mindpet/screens/nueva_entrada_screen.dart';
import '../widgets/tarjeta_emocion.dart';

class DiarioScreen extends StatefulWidget {
  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {

  List<Map<String,dynamic>> entradas = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Color(0xffdbe7ef),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Diario",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),

        onPressed: () async {

          final nuevaEntrada = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NuevaEntradaScreen(),
            ),
          );

          if(nuevaEntrada != null){
            setState(() {
              entradas.add(nuevaEntrada);
            });
          }

        },
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: ListView.builder(

          itemCount: entradas.length,

          itemBuilder: (context,index){

            final entrada = entradas[index];

            return TarjetaEmocion(
              emocion: entrada["emocion"],
              titulo: entrada["titulo"],
              texto: entrada["texto"],
              color: entrada["color"],
            );

          },
        ),
      ),
    );
  }
}