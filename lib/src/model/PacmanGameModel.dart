part of pacmanLib;

class PacmanGameModel {
  List<Ghost> _ghosts = new List();
  Pacman _pacman;

  bool _gameOver = false;
  int _size = 0;

  Level _level;
  int _currentLevel = -1;

  PacmanGameModel() {
    LevelLoader.loadConfig();
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
  void moveUp() => _pacman.move(Directions.UP);

  /**
   * moves [Pacman] down if possible
   */
  void moveDown() => _pacman.move(Directions.DOWN);

  /**
   * moves [Pacman] left if possible
   */
  void moveLeft() => _pacman.move(Directions.LEFT);

  /**
   * moves [Pacman] right if possible
   */
  void moveRight() => _pacman.move(Directions.RIGHT);

  /**
   * Moves all [Ghost]s
   */
  void moveGhost() => _ghosts.forEach((g) => g.move());

  List<List<Statics>> getStaticMap() {
    if (_level == null) return null;
    return _level.getStaticMap();
  }

  List<List<Dynamics>> getDynamicMap() {
    if (_level == null) return null;
    return _level.getDynamicMap();
  }

  List<List<Items>> getItemMap() {
    if (_level == null) return null;

    return _level.getIemMap();
  }

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
