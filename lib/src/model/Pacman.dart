part of pacmanLib;

class Pacman extends GameElement {
  double _speed; // TODO speed
  int _lives;

  Pacman(int x, int y, bool collPlayer, bool collGhost, int lives)
      : super(x, y, collPlayer, collGhost),
        this._lives = lives;

  void move(Directions dir) {}

  void decreaseLife() {}
}
