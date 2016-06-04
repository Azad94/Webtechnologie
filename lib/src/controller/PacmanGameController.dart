part of pacmanLib;

//the refreshrate of the view
const speed = const Duration(milliseconds:400);

class PacmanGameController {
  //instances of PacmanGameModel and PacmanGameView
  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;
  GameKeyClient _gamekey;
  //the current Direction of Pacman
  Directions pacmanDir = Directions.RIGHT;

  //keyListener for User interaction and timer for the refreshrate
  var _keyListener;
  Timer _timer;

  int _currentLevel = 1;
  int _maxLevel = 3;

  int achievedScore = 0;
  //mobile Keys
  var up;
  var down;
  var left;
  var right;
  //constructor
  PacmanGameController() {
    _pacmanModel = new PacmanGameModel(this);
    _pacmanView = new PacmanGameView(this);
    _pacmanModel.loadLevel(_currentLevel).whenComplete(() => authenticateUser()); // HIER ÄNDERUNG EINGEFÜGT
   //_gamekey = new GameKeyClient(LevelLoader.GAMEKEY_HOST, LevelLoader.GAMEKEY_PORT, LevelLoader.GAMEKEY_ID, LevelLoader.GAMEKEY_SECRET);
  }

  //TODO user authentication
  Future authenticateUser() async {
    _gamekey = new GameKeyClient(LevelLoader._gamekeyHost, LevelLoader._gamekeyPort, LevelLoader._gamekeyID, LevelLoader._gamekeySecret);
    await _gamekey.authenticate();
    _pacmanView.showGame();
    _pacmanView.hideLoading();
    startGame();
  }

  //start new game
  void startGame() {
    if(_gamekey._available){
      _pacmanView.updateMessages("Gamekey available", true);
    }else{
      _pacmanView.updateMessages("Gamekey unavailable", false);
    }
    if(_currentLevel>1){
      _pacmanView.hideOverlay();
    }
    if(_currentLevel==_maxLevel){
      _pacmanView.hideNextLevel();
    }
    var labyrinth = _pacmanModel.getMap();
    if(_currentLevel==1){
      createTable(labyrinth);
    }
    refreshLabyrinth(labyrinth);
    _timer = new Timer.periodic(speed, (_) {_pacmanModel.triggerFrame(); });

    if(_pacmanView.mql.matches){
      up = _pacmanView.mobileUp.onClick.listen((_) {_pacmanModel.moveUp();});
      down = _pacmanView.mobileDown.onClick.listen((_) {_pacmanModel.moveDown();});
      left = _pacmanView.mobileLeft.onClick.listen((_) {_pacmanModel.moveLeft();});
      right = _pacmanView.mobileRight.onClick.listen((_) {_pacmanModel.moveRight();});
    } else {
      _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
        ev.preventDefault();
        switch (ev.keyCode) {
          case KeyCode.LEFT:
            _pacmanModel.moveLeft();
            break;
          case KeyCode.RIGHT:
            _pacmanModel.moveRight();
            break;
          case KeyCode.DOWN:
            _pacmanModel.moveDown();
            break;
          case KeyCode.UP:
            _pacmanModel.moveUp();
            break;
        }
      });
    }
  }

  //create the table in the view
  void createTable(List<List<Types>> l) {
    _pacmanView.initTable(l);
  }

  //load the current game elements and graphis into the table
  void refreshLabyrinth(List<List<Types>> l) {
    _pacmanView._labyrinthFill(l);
  }

  //updates the current view
  void updateGameStatus() {
    updateScore();
    updateLevel();
    updateLives();
    var labyrinth = _pacmanModel.getMap();
    refreshLabyrinth(labyrinth);
    gameOver(_pacmanModel.gameEnd);
    gameWon(_pacmanModel.gameVic);
  }

  //ends the game, lost
  void gameOver(bool b) {
    if (b) {
      stopGame();
      _pacmanView.hideNextLevel();
      _pacmanView.updateOverlay("GAME OVER");
      if(_gamekey._available){
      _pacmanView.showHighscore();
      _pacmanView.savename.onClick.listen((_) { saveScore();/*_gamekey.authenticate();*/});}
    }
  }

    void saveScore() {
      if(_gamekey._available){
        achievedScore+=_pacmanModel.score;
        _gamekey.addScore(_pacmanView.user, achievedScore).then((b) { _gamekey.getTop10().then((scores) { _pacmanView.showTop10(scores, achievedScore);});} );
      }
    }

  //ends the game, won
  void gameWon(bool b) {
    if (b) {
      stopGame();
      achievedScore += _pacmanModel.score;
      _pacmanView.updateOverlay("STAGE CLEARED");
      _pacmanModel.newGame();
      _currentLevel++;
      _pacmanView.startNext.onClick.listen((_) {_pacmanModel.loadLevel(_currentLevel).whenComplete(() => startGame());});
    }
  }

  //stops interaction
  void stopGame() {
    if (_pacmanView.mql.matches) {
      up.cancel();
      down.cancel();
      left.cancel();
      right.cancel();
    } else {
      _keyListener.cancel();
    }
    _timer.cancel();
  }

  //set the direction for pacman to choose the right graphic
  void setPacmanDir(Directions p) {
    this.pacmanDir = p;
  }

  //let the view display the current score
  void updateScore() {
    _pacmanView.updateScore(_pacmanModel.score);
  }

  void updateLevel() {
    _pacmanView.updateLevel(_pacmanModel.level);
  }

  void updateLives() {
    _pacmanView.updateLives(_pacmanModel.lives);
  }

}
