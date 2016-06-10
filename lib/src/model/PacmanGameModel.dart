part of pacmanLib;

class PacmanGameModel {
  List<Ghost> _ghosts = new List();
  List<Cherry> _cherrys = new List();
  Pacman _pacman;
  PacmanGameController _con;
  Directions _pacmanDir = Directions.NOTHING;

  bool _gameOver = false;
  bool _gameWon = false;
  bool _hasBonus = false;

  Level _level;
  int _currentLevel = -1;

  PacmanGameModel(PacmanGameController con) {
    this._con = con;
  }

  /**
   * return true if the game is game over, else false
   */
  bool get gameEnd => _gameOver;
  bool get gameVic => _gameWon;

  int get level => _level._levelNumber;

  /**
   * return the lives of [Pacman]
   */
  int get lives => _pacman._lives;

  /**
   * return the current score
   */
  int get score => _level.score;

  void errorScreen() => _con.toggleErrorScreen();

  /**
   * enable the power mode, means that ghosts are eatable
   */
  void enablePowerMode() => _ghosts.forEach((g) => g.eatableMode());

  /**
   * set the game to game over
   */
  void gameOver() {
    _gameOver = true;
  }

  void gameWon() {
    _gameWon = true;
  }

  bool getGameOver() => false;

  bool getGameWone() => false;

  Future<bool> loadConfig() async => await LevelLoader.loadConfig();

  /**
   * return the full gameField as list over list with enum [Type]
   */
  List<List<Types>> getMap() => _level.getMap();

  Future<bool> loadLevel(int level) async {
    // Delete old references
    _pacman = null;
    _ghosts = new List();
    if (!await LevelLoader.loadLevel(level)) return false;
    _currentLevel = LevelLoader._levelNumber;
    if(LevelLoader._bonus) {
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
    }
    else {
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
   * moves [Pacman] down if possible
   */
  void moveDown() {
    _pacmanDir = Directions.DOWN;
  }

  /**
   * Moves all [Ghost]s DO NOT CALL
   */
  void moveGhost() {
    _ghosts.forEach((g) {
      if (g != null) g.move();
    });
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
   * moves [Pacman] up if possible
   */
  void moveUp() {
    _pacmanDir = Directions.UP;
  }

  void newGame() {
    _gameOver = false;
    _gameWon = false;
    _hasBonus = false;
    _pacman = null;
    _ghosts = new List();
    _cherrys = new List();
    Item.resetCounter();
  }

  /**
   * register a new [GameElement]
   */
  void registerGameElement(GameElement g) {
    if (g is Ghost) _ghosts.add(g);
    if (g is Pacman) _pacman = g;
    if (g is Cherry) _cherrys.add(g);
  }

  /**
   * respawns all [Ghost]s
   */
  void respawnGhosts() => _ghosts.forEach((g) {
        if (g != null) g.respwan();
      });

  void _openWall() {
    _level._openWall();
  }

  void _closeWall() {
    _level._closeWall();
  }

  void _joinBonusLevel() {
    _con.loadBonusLevel();
  }

  /**
   * move [Pacman] and [Ghost] to the next position. Call this method each frame.
   */
  void triggerFrame() {
    _level.pacmanDir = _pacmanDir;
    if (_pacman != null) _pacman.move(_pacmanDir);
    _pacmanDir = Directions.NOTHING;
    this.moveGhost();
    _cherrys.forEach((c) => c.triggerFrame());
    this.updateView();
  }

  void updateView() {
    _con.updateGameStatus();
  }
}
