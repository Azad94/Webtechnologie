part of pacmanLib;

class PacmanGameModel {
  List<Ghost> _ghosts = new List();
  Pacman _pacman;
  PacmanGameController _con;
  Directions _pac_dir = Directions.NOTHING;

  bool _gameOver = false;
  bool _gameWon = false;
  int _sizeX;
  int _sizeY;

  Level _level;
  LevelLoader _levelloader = new LevelLoader();
  int _currentLevel = -1;

  PacmanGameModel(PacmanGameController con) {
    LevelLoader.loadConfig();
    _sizeX = LevelLoader.sizeX;
    _sizeY = LevelLoader.sizeY;
    this._con = con;
  }

  bool getGameOver() => false;
  bool getGameWone() => false;

  int getCurrentLevel() => _currentLevel;

 /* void loadLevel(int level) {
    // Delete old references
    _pacman = null;
    _ghosts = new List();
    print("Step 1");
    _levelloader.loadLevel(level);}*/
  Future loadLevel(int level) {
    HttpRequest.getString("${level}_Level.json").then((loadLevel2));
  }

  void loadLevel2(String uri){
    final data = JSON.decode(uri);
    LevelLoader.levelNumber = data["level"];
    LevelLoader.sizeX = data["sizeX"];
    LevelLoader.sizeY = data["sizeY"];
    LevelLoader._map = data["map"];
    LevelLoader._lives = data["lives"];
    LevelLoader._eatTime = data["ghostEatTime"];
    LevelLoader._startBlinky = data["startBlinky"];
    LevelLoader._startClyde = data["startClyde"];
    LevelLoader._startInky = data["startInky"];
    LevelLoader._startPinky = data["startPinky"];
    LevelLoader._loaded = true;
    print("Step 2");
    print(LevelLoader._map);
    _currentLevel = LevelLoader.levelNumber;
    print("Step 3");
    _level = new Level(
        LevelLoader._map,
        LevelLoader.sizeX,
        LevelLoader.sizeY,
        LevelLoader._lives,
        LevelLoader.SCORE_PILL,
        LevelLoader.SCORE_CHERRY,
        LevelLoader.SCORE_POWERPILL,
        LevelLoader.SCORE_GHOST,
        LevelLoader._eatTime,
        LevelLoader._startBlinky,
        LevelLoader._startClyde,
        LevelLoader._startInky,
        LevelLoader._startPinky,
        this);
        if(LevelLoader.levelNumber==1){
          print("LEVELNUMBER1:" + LevelLoader.levelNumber.toString());
          _con.startGame();}
        if(LevelLoader.levelNumber==2){
          print("LEVELNUMBER2:" + LevelLoader.levelNumber.toString());
          _con.startNextLevel();
        }
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
    _level.pacmanDir = _pac_dir;
    _pacman.move(_pac_dir);
    _pac_dir = Directions.NOTHING;
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

  int get level => LevelLoader.levelNumber;

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
