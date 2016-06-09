part of pacmanLib;

class PacmanGameModel {
  List<Ghost> _ghosts = new List();
  Pacman _pacman;
  PacmanGameController _con;
  Directions _pacmanDir = Directions.NOTHING;

  bool _gameOver = false;
  bool _gameWon = false;
  int _sizeX;
  int _sizeY;

  Level _level;
  int _currentLevel = -1;

  PacmanGameModel(PacmanGameController con) {
   // LevelLoader.loadConfig();
    _sizeX = LevelLoader._sizeX;
    _sizeY = LevelLoader._sizeY;
    this._con = con;
  }

  /**
   * return true if the game is game over, else false
   */
  bool get gameEnd => _gameOver;
  bool get gameVic => _gameWon;

  int get level => LevelLoader._levelNumber;

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

  int getCurrentLevel() => _currentLevel;

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
    _level = new Level(
        LevelLoader._map,
        LevelLoader._sizeX,
        LevelLoader._sizeY,
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
    Item.resetCounter();
  }

  /**
   * register a new [GameElement]
   */
  void registerGameElement(GameElement g) {
    if (g is Ghost) _ghosts.add(g);
    if (g is Pacman) _pacman = g;
  }

  /**
   * respawns all [Ghost]s
   */
  void respawnGhosts() => _ghosts.forEach((g) {
        if (g != null) g.respwan();
      });

  /**
   * move [Pacman] and [Ghost] to the next position. Call this method each frame.
   */
  void triggerFrame() {
    _level.pacmanDir = _pacmanDir;
    if (_pacman != null) _pacman.move(_pacmanDir);
    _pacmanDir = Directions.NOTHING;
    this.moveGhost();
    this.updateView();
  }

  void updateView() {
    _con.updateGameStatus();
  }
}
