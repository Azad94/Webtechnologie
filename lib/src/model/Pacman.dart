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
   * time(frames) who long pacman is in PowerMode
   */
  int _powerTime;

  /**
   * counter for counting frames
   */
  int _frameCounter = 0;

  /**
   * is Pacman in PowerMode?
   */
  bool _powerMode = false;

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
      this._level, this._model, this._powerTime)
      : super(x, y, collPlayer, collGhost),
        this._start_x = x,
        this._start_y = y;

  /**
   * moves [Pacman] in the given [Directions].
   */
  void _move(Directions dir) {
    switch (dir) {
      case Directions.UP:
        if (!_level._checkCollision(_x, _y - 1, this))
          _level._registerElement(_x, _y, _x, --_y, this);
        break;
      case Directions.DOWN:
        if (!_level._checkCollision(_x, _y + 1, this))
          _level._registerElement(_x, _y, _x, ++_y, this);
        break;
      case Directions.LEFT:
        if (!_level._checkCollision(_x - 1, _y, this))
          _level._registerElement(_x, _y, --_x, _y, this);
        break;
      case Directions.RIGHT:
        if (!_level._checkCollision(_x + 1, _y, this))
          _level._registerElement(_x, _y, ++_x, _y, this);
        break;
      default:
        if (!_powerMode) this._possiblePacmanWay(_x, _y, this);
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
    _level._registerElement(_x, _y, _start_x, _start_y, this);
    _x = _start_x;
    _y = _start_y;
  }

  /**
   * called every frame. Count frames an disable Powermode after _powerTime.
   */
  void _triggerFrame() {
    if (_powerMode) {
      if (++_frameCounter == _powerTime) {
        _powerMode = false;
        _level._disablePacmanPowerMode();
      }
    }
  }

  /**
   * starts pacman PowerMode
   */
  void _activatePowerMode() {
    print("pacman active");
    _powerMode = true;
  }

  /**
   * DO NOT CALL; PRIAVTE
   * checks if [Pacman] has got a way
   */
  void _possiblePacmanWay(int x, int y, Pacman p) {
    if (_level._checkCollision(x - 1, y, p) &&
        _level._checkCollision(x + 1, y, p) &&
        _level._checkCollision(x, y - 1, p) &&
        _level._checkCollision(x, y + 1, p)) {
      p._decreaseLife();
      p._respawn();
      _model._respawnGhosts();
    }
  }
}
