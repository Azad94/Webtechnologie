part of pacmanLib;

class PacmanGameModel {
  bool _pause = false;
  bool _gameOver = false;
  int _size = 0;

  Level _level;
  int _currentLevel = -1;

  bool getGameOver() => false;

  int getCurrentLevel() => _currentLevel;

  void loadLevel(int level) {
    LevelLoader.loadLevel(level);
    _currentLevel = LevelLoader.levelNumber;
    _level = new Level(LevelLoader._map, LevelLoader.sizeX, LevelLoader.sizeY);
  }

  void moveUp() {}

  void moveDown() {}

  void moveLeft() {}

  void moveRight() {}

  void pauseGame() {}

  void moveGhost() {}

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
}
