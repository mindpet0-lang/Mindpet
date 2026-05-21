import 'package:flutter/material.dart';

class VictoriaAnimada extends StatefulWidget {
  final VoidCallback onRestart;

  const VictoriaAnimada({required this.onRestart});

  @override
  _VictoriaAnimadaState createState() => _VictoriaAnimadaState();
}

class _VictoriaAnimadaState extends State<VictoriaAnimada>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<Offset> slideAnimation;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack, 
      ),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.3, 1),
      ),
    );

    scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Stack(
  alignment: Alignment.center,
  children: [

    // 🖼 IMAGEN CON BORDES REDONDEADOS
    ClipRRect(
      borderRadius: BorderRadius.circular(30), // 
      child: Image.asset(
        "juegos/images/juego2/victoria.png",
        width: 320,
      ),
    ),

    // 🔘 BOTÓN ENCIMA (posición personalizada)
    Positioned(
      bottom: 25, // 👈 ajusta esto para moverlo más abajo/arriba
      child: GestureDetector(
        onTap: widget.onRestart,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFB8A1FF),
                Color(0xFF8EC5FF),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            "Jugar de nuevo",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  ],
)
            ),
          ),
        ),
      ),
    );
  }
}