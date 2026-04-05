import 'package:flutter/material.dart';

class TarjetaEmocion extends StatelessWidget {

  final String emocion;
  final String titulo;
  final String texto;
  final Color color;

  const TarjetaEmocion({
    super.key,
    required this.emocion,
    required this.titulo,
    required this.texto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: EdgeInsets.only(bottom:15),
      padding: EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Color(0xffa9c7da),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width:10,
                height:10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

              SizedBox(width:8),

              Text(
                emocion,
                style: TextStyle(fontWeight: FontWeight.bold),
              )

            ],
          ),

          SizedBox(height:5),

          Text(
            titulo,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Text(texto)

        ],
      ),
    );
  }
}