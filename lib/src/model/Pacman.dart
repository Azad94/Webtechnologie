part of pacmanLib;

class Pacman extends GameElement {
  final _start_x, _start_y;
  int _lives;
  Level _level;
  PacmanGameModel _model;

  Pacman(int x, int y, bool collPlayer, bool collGhost, int lives, Level l,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost),
        this._lives = lives,
        this._level = l,
        this._model = model,
        this._start_x = x,
        this._start_y = y;

  /**
   * moves [Pacman] in the given [Directions].
   */
  void move(Directions dir) {
    switch (dir) {
      case Directions.UP:
        if (!_level.checkCollision(_x, _y - 1, this))
          _level.registerElement(_x, _y, _x, --_y, this);
        break;
      case Directions.DOWN:
        if (!_level.checkCollision(_x, _y + 1, this))
          _level.registerElement(_x, _y, _x, ++_y, this);
        break;
      case Directions.LEFT:
        if (!_level.checkCollision(_x - 1, _y, this))
          _level.registerElement(_x, _y, --_x, _y, this);
        break;
      case Directions.RIGHT:
        if (!_level.checkCollision(_x + 1, _y, this))
          _level.registerElement(_x, _y, ++_x, _y, this);
        break;
      default:
        break;
    }
  }

  void decreaseLife() {
    if (--_lives == 0) {
      _model.gameOver();
    }
  }

  void respawn() {
    _level.registerElement(_x, _y, _start_x, _start_y, this);
    _x = _start_x;
    _y = _start_y;
  }
}
