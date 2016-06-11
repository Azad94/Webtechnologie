part of pacmanModelLib;

/**
 * Model of Pacman game
 */
class PacmanGameModel {
  /**
   * is player game over?
   */
  bool _gameOver = false;

  /**
   * game won?
   */
  bool _gameWon = false;

  /**
   * has got level a bonus level?
   */
  bool _hasBonus = false;

  /**
   * current level number
   */
  int _currentLevel = -1;

  /**
   * Direction of [Pacman]s next step
   */
  Directions _pacmanDir = Directions.NOTHING;

  /**
   * all ghosts on the field. Used for moving ghosts
   */
  List<Ghost> _ghosts = new List();

  /**
   * all cherrys on the field. Used for entering bonus level.
   */
  List<Cherry> _cherrys = new List();

  /**
   * Pacman
   */
  Pacman _pacman;

  /**
   * the current played level
   */
  Level _level;

  /**
   * Controller
   */
  PacmanGameController _con;

  /**
   * creates a new Model
   */
  PacmanGameModel(this._con);

  /**
   * return true if the game is game over, else false
   */
  bool get gameEnd => _gameOver;

  /**
   * return true if player won the game. else false
   */
  bool get gameVic => _gameWon;

  /**
   * return the current level number
   */
  int get level => _level._levelNumber;

  /**
   * return the lives of [Pacman]
   */
  int get lives => _pacman._lives;

  /**
   * return the current score
   */
  int get score => _level.score;

  /**
   * set game won
   */
  void gameWon() {
    _gameWon = true;
  }

  /**
   * load the config data for pacman game
   */
  Future<bool> loadConfig() async => await LevelLoader.loadConfig();

  /**
   * return the full gameField as list over list with enum [Type]
   */
  List<List<Types>> getMap() => _level.getMap();

  /**
   * load a level by given level number
   */
  Future<bool> loadLevel(int level) async {
    // Delete old references
    _pacman = null;
    _ghosts = new List();
    _cherrys = new List();

    if (!await LevelLoader.loadLevel(level)) return false;
    _currentLevel = LevelLoader._levelNumber;
    if (LevelLoader._bonus) {
      _level = new Level(
          LevelLoader._map,
          LevelLoader._sizeX,
          LevelLoader._sizeY,
          LevelLoader._levelNumber,
          LevelLoader._lives,
          LevelLoader._scorePill,
          LevelLoader._scoreCherry,
          LevelLoader._scorePowerPill,
          LevelLoader._scoreGhost,
          LevelLoader._eatTime,
          LevelLoader._startBlinky,
          LevelLoader._startClyde,
          LevelLoader._startInky,
          LevelLoader._startPinky,
          this,
          LevelLoader._portX,
          LevelLoader._portY,
          LevelLoader._openTime);
      _hasBonus = true;
    } else {
      _level = new Level(
          LevelLoader._map,
          LevelLoader._sizeX,
          LevelLoader._sizeY,
          LevelLoader._levelNumber,
          LevelLoader._lives,
          LevelLoader._scorePill,
          LevelLoader._scoreCherry,
          LevelLoader._scorePowerPill,
          LevelLoader._scoreGhost,
          LevelLoader._eatTime,
          LevelLoader._startBlinky,
          LevelLoader._startClyde,
          LevelLoader._startInky,
          LevelLoader._startPinky,
          this);
    }
    return true;
  }

  /**
   * moves [Pacman] up if possible
   */
  void moveUp() {
    _pacmanDir = Directions.UP;
  }

  /**
   * moves [Pacman] down if possible
   */
  void moveDown() {
    _pacmanDir = Directions.DOWN;
  }

  /**
   * moves [Pacman] left if possible
   */
  void moveLeft() {
    _pacmanDir = Directions.LEFT;
  }

  /**
   * moves [Pacman] right if possible
   */
  void moveRight() {
    _pacmanDir = Directions.RIGHT;
  }

  /**
   * starts a new game
   */
  void newGame() {
    _gameOver = false;
    _gameWon = false;
    _hasBonus = false;
    Item.resetCounter();
  }

  /**
   * move [Pacman] and [Ghost] to the next position. Call this method each frame.
   */
  void triggerFrame() {
    _level.pacmanDir = _pacmanDir;
    if (_pacman != null) _pacman.move(_pacmanDir);
    _pacmanDir = Directions.NOTHING;
    this._moveGhost();
    _cherrys.forEach((c) => c.triggerFrame());
    _con.updateGameStatus();
  }

  /**
   * Removes a Wall for entering into bonus level
   */
  void _openWall() {
    _level._openWall();
  }

  /**
   * add the Wall, where wall for bonus level was removed
   */
  void _closeWall() {
    _level._closeWall();
  }

  /**
   * set the game to game over
   */
  void _gameFinished() {
    _gameOver = true;
  }

  /**
   * enable the power mode, means that ghosts are eatable
   */
  void _enablePowerMode() => _ghosts.forEach((g) => g.eatableMode());

  /**
   * start loading bonus level
   */
  void _joinBonusLevel() {
    _con.loadBonusLevel();
  }

  /**
   * respawns all [Ghost]s
   */
  void _respawnGhosts() => _ghosts.forEach((g) {
        if (g != null) g.respwan();
      });

  /**
   * register a new [GameElement]
   */
  void _registerGameElement(GameElement g) {
    if (g is Ghost) _ghosts.add(g);
    if (g is Pacman) _pacman = g;
    if (g is Cherry) _cherrys.add(g);
  }

  /**
   * show error screen on view
   */
  void _errorScreen() => _con.toggleErrorScreen();

  /*
   * local helper methods
   */
  /////////////////////////////////////////////////////////////////////////////////
  /**
   * DO NOT CALL; PRIVATE
   * Moves all [Ghost]s
   */
  void _moveGhost() {
    _ghosts.forEach((g) {
      if (g != null) g.move();
    });
  }
}
