class Pet {

  int energia;
  int felicidad;
  int higiene;
  int hambre;

  Pet({
    this.energia = 80,
    this.felicidad = 80,
    this.higiene = 80,
    this.hambre = 20,
  });

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
    energia -= 10;

    if (felicidad > 100) felicidad = 100;
    if (energia < 0) energia = 0;
  }

}