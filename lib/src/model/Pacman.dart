part of pacmanModelLib;

/**
 * represents pacman, controlled by player
 */
class Pacman extends GameElement {
  /**
   * default start position
   */
  final _start_x, _start_y;

  /**
   * lives of pacman
   */
  int _lives;

  /**
   * level
   */
  Level _level;

  /**
   * model
   */
  PacmanGameModel _model;

  /**
   * creates a new Pacman
   */
  Pacman(int x, int y, bool collPlayer, bool collGhost, this._lives,
      this._level, this._model)
      : super(x, y, collPlayer, collGhost),
        this._start_x = x,
        this._start_y = y;

  /**
   * moves [Pacman] in the given [Directions].
   */
  void _move(Directions dir) {
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

  /**
   * decrease pacmans lives by one
   */
  void _decreaseLife() {
    if (--_lives == 0) {
      _model._gameFinished();
    }
  }

  /**
   * respawn pacman to default position
   */
  void _respawn() {
    _level.registerElement(_x, _y, _start_x, _start_y, this);
    _x = _start_x;
    _y = _start_y;
  }
}
