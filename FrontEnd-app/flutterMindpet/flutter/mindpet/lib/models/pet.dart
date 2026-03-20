import 'package:shared_preferences/shared_preferences.dart';

class Pet {

  int energia;
  int felicidad;
  int higiene;
  int hambre;
  int lastUpdate; // tiempo guardado

  Pet({
    this.energia = 80,
    this.felicidad = 80,
    this.higiene = 80,
    this.hambre = 20,
    int? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now().millisecondsSinceEpoch;

  /// ACCIONES
  void banarse() {
    higiene += 20;
    if (higiene > 100) higiene = 100;
  }

  void comer() {
    hambre -= 20;
    if (hambre < 0) hambre = 0;
  }

  void dormir() {
    energia += 30;
    if (energia > 100) energia = 100;
  }

  void jugar() {
    felicidad += 20;
    energia -= 15;

    if (felicidad > 100) felicidad = 100;
    if (energia < 0) energia = 0;
  }

  /// 🔥 BAJAR ESTADOS CON EL TIEMPO
  void updateWithTime() {

    int now = DateTime.now().millisecondsSinceEpoch;
    int diff = now - lastUpdate;

    int seconds = diff ~/ 1000;

    if (seconds > 0) {

      energia -= seconds ~/ 5;
      felicidad -= seconds ~/ 6;
      higiene -= seconds ~/ 7;
      hambre += seconds ~/ 5;

      _clamp();

      lastUpdate = now;
    }
  }

  void _clamp() {
    energia = energia.clamp(0, 100);
    felicidad = felicidad.clamp(0, 100);
    higiene = higiene.clamp(0, 100);
    hambre = hambre.clamp(0, 100);
  }

  /// 💾 GUARDAR
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt('energia', energia);
    prefs.setInt('felicidad', felicidad);
    prefs.setInt('higiene', higiene);
    prefs.setInt('hambre', hambre);
    prefs.setInt('lastUpdate', lastUpdate);
  }

  /// 📥 CARGAR
  static Future<Pet> load() async {
    final prefs = await SharedPreferences.getInstance();

    Pet pet = Pet(
      energia: prefs.getInt('energia') ?? 80,
      felicidad: prefs.getInt('felicidad') ?? 80,
      higiene: prefs.getInt('higiene') ?? 80,
      hambre: prefs.getInt('hambre') ?? 20,
      lastUpdate: prefs.getInt('lastUpdate'),
    );

    pet.updateWithTime(); // 🔥 aplica tiempo pasado

    return pet;
  }
}