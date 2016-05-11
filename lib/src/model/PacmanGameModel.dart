part of pacmanLib;

class PacmanGameModel {
  List<Ghost> _ghosts = new List();
  Pacman _pacman;
  Directions _pac_dir = Directions.NOTHING;

  bool _gameOver = false;
  int _sizeX;
  int _sizeY;

  Level _level;
  int _currentLevel = -1;

  PacmanGameModel() {
    LevelLoader.loadConfig();
    _sizeX = LevelLoader.sizeX;
    _sizeY = LevelLoader.sizeY;
  }

  bool getGameOver() => false;

  int getCurrentLevel() => _currentLevel;

  void loadLevel(int level) {
    // Delete old references
    _pacman = null;
    _ghosts = new List();
    LevelLoader.loadLevel(level);
    _currentLevel = LevelLoader.levelNumber;
    _level = new Level(
        LevelLoader._map,
        LevelLoader.sizeX,
        LevelLoader.sizeY,
        LevelLoader._lives,
        LevelLoader.SCORE_PILL,
        LevelLoader.SCORE_CHERRY,
        LevelLoader.SCORE_POWERPILL,
        this);
  }

  /**
   * moves [Pacman] up if possible
   */
  void moveUp() {
    _pac_dir = Directions.UP;
  }

  /**
   * moves [Pacman] down if possible
   */
  void moveDown() {
    _pac_dir = Directions.DOWN;
  }

  /**
   * moves [Pacman] left if possible
   */
  void moveLeft() {
    _pac_dir = Directions.LEFT;
  }

  /**
   * moves [Pacman] right if possible
   */
  void moveRight() {
    _pac_dir = Directions.RIGHT;
  }

  /**
   * move [Pacman] and [Ghost] to the next position. Call this method each frame.
   */
  void triggerFrame() {
    this.moveGhost();
    _pacman.move(_pac_dir);
    _pac_dir = Directions.NOTHING;
  }

  /**
   * set the game to game over
   */
  void gameOver() {
    _gameOver = true;
  }

  /**
   * enable the power mode, means that ghosts are eatable
   */
  void enablePowerMode() => _ghosts.forEach((g) => g.eatableMode());

  void updateView() {

  }

  /**
   * Moves all [Ghost]s DO NOT CALL
   */
  void moveGhost() => _ghosts.forEach((g) => g.move());

  /**
   * DEPRECATED
   */
  List<List<Statics>> getStaticMap() {
    if (_level == null) return null;
    return _level.getStaticMap();
  }

  /**
   *DEPRECATED
   */
  List<List<Dynamics>> getDynamicMap() {
    if (_level == null) return null;
    return _level.getDynamicMap();
  }

  /**
   *DEPRECATED
   */
  List<List<Items>> getItemMap() {
    if (_level == null) return null;

    return _level.getIemMap();
  }

  /**
   * return the full gameField as list over list with enum [Type]
   */
  List<List<Types>> getMap() => _level.getMap();

  /**
   * return the current score
   */
  int getScore() => Item._scoreCounter;

  /**
   * register a new [GameElement]
   */
  void registerGameElement(GameElement g) {
    if (g is Ghost) _ghosts.add(g);
    if (g is Pacman) _pacman = g;
  }

  Level returnLevel() => _level;
  Pacman returnPacman() => _pacman;
}
