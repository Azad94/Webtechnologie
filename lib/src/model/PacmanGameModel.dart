part of pacman;

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
    _level = new Level(LevelLoader._environment);
  }

  void moveUp() {}

  void moveDown() {}

  void moveLeft() {}

  void moveRight() {}

  void pauseGame() {}

  void moveGhost() {}

  void getEnvironmentMap() {}

  void getDynamicMap() {}

  void getItemMap() {}
}
