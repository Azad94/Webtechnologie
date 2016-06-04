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
    LevelLoader.loadConfig();
    _sizeX = LevelLoader._sizeX;
    _sizeY = LevelLoader._sizeY;
    this._con = con;
  }

  bool getGameOver() => false;
  bool getGameWone() => false;

  int getCurrentLevel() => _currentLevel;

  Future loadLevel(int level) async {
    // Delete old references
    _pacman = null;
    _ghosts = new List();
    await LevelLoader.loadLevel(level);
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
   * move [Pacman] and [Ghost] to the next position. Call this method each frame.
   */
  void triggerFrame() {
    _level.pacmanDir = _pacmanDir;
    _pacman.move(_pacmanDir);
    _pacmanDir = Directions.NOTHING;
    this.moveGhost();
    this.updateView();
  }

  /**
   * set the game to game over
   */
  void gameOver() {
    _gameOver = true;
  }

  void gameWon() {
    _gameWon = true;
  }
  void newGame() {
    _gameOver = false;
    _gameWon = false;
  }
  /**
   * enable the power mode, means that ghosts are eatable
   */
  void enablePowerMode() => _ghosts.forEach((g) => g.eatableMode());

  void updateView() {
    _con.updateGameStatus();
  }

  /**
   * Moves all [Ghost]s DO NOT CALL
   */
  void moveGhost() {
    _ghosts.forEach((g) => g.move());
  }

  /**
   * respawns all [Ghost]s
   */
  void respawnGhosts() => _ghosts.forEach((g) => g.respwan());

  /**
   * return the full gameField as list over list with enum [Type]
   */
  List<List<Types>> getMap() => _level.getMap();

  /**
   * return the current score
   */
  int get score => _level.score;

  /**
   * return the lives of [Pacman]
   */
  int get lives => _pacman._lives;

  /**
   * return true if the game is game over, else false
   */
  bool get gameEnd => _gameOver;
  bool get gameVic => _gameWon;

  int get level => LevelLoader._levelNumber;

  /**
   * register a new [GameElement]
   */
  void registerGameElement(GameElement g) {
    if (g is Ghost) _ghosts.add(g);
    if (g is Pacman) _pacman = g;
  }
}
