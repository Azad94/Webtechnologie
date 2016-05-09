part of pacmanLib;

class Pacman extends GameElement {
  double _speed; // TODO speed
  int _lives;
  Level _level;

  Pacman(int x, int y, bool collPlayer, bool collGhost, int lives, Level l)
      : super(x, y, collPlayer, collGhost),
        this._lives = lives,
        this._level = l;

  /**
   * moves [Pacman] in the given [Directions].
   */
  void move(Directions dir) {
    if (dir == Directions.UP) {
      if (!_level.checkCollision(_x, _y - 1, this))
        _level.registerElement(_x, _y, _x, --_y, this);
    }
    if (dir == Directions.DOWN) {
      if (!_level.checkCollision(_x, _y + 1, this))
        _level.registerElement(_x, _y, _x, ++_y, this);
    }
    if (dir == Directions.LEFT) {
      if (!_level.checkCollision(_x - 1, _y, this))
        _level.registerElement(_x, _y, --_x, _y, this);
    }
    if (dir == Directions.RIGHT) {
      if (!_level.checkCollision(_x + 1, _y, this))
        _level.registerElement(_x, _y, ++_x, _y, this);
    }
  }

  void decreaseLife() {
    /* TODO reaction */
    print("decreaseLife");
  }
}
