import 'package:flutter/material.dart';

class DerrotaAnimada extends StatefulWidget {
  final VoidCallback onRestart;

  const DerrotaAnimada({required this.onRestart});

  @override
  _DerrotaAnimadaState createState() => _DerrotaAnimadaState();
}

class _DerrotaAnimadaState extends State<DerrotaAnimada>
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

                  // 🖼 IMAGEN DERROTA
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "juegos/images/juego2/derrota.png", 
                      width: 300,
                    ),
                  ),

                  // 🔘 BOTÓN
                  Positioned(
                    bottom: 25,
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
                              Color(0xFFA084E8), // más morado triste
                              Color(0xFF6C8EFF),
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
                          "Intentar otra vez", 
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}