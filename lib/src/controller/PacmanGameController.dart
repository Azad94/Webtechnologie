part of pacmanControllerLib;

/**
 * the refreshrate of the view
 */
const speed = const Duration(milliseconds: 400);

class PacmanGameController {
  /**
   * instances of PacmanGameModel, PacmanGameView & GameKeyClient
   */
  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;
  GameKeyClient _gamekey;

  /**
   * the current Direction of Pacman
   */
  Directions _pacmanDir = Directions.RIGHT;

  /**
   * keyListener for User interaction
   * timer for the refreshrate
   */
  var _keyListener;
  Timer _timer;
  int _currentLevel = 1;
  int _maxLevel = 3;

  /**
   * a few different values, if the game is paused, an error occured an the achievedScore during a session
   */
  bool _paused = false;
  bool _err = false;
  int _achievedScore = 0;

  /**
   * the differen mobile keys,
   */
  var _up;
  var _down;
  var _left;
  var _right;
  var _pause;

  /**
   * creates a Controller
   */
  PacmanGameController() {
    _pacmanModel = new PacmanGameModel(this);
    _pacmanView = new PacmanGameView(this);
    _pacmanModel.loadConfig().then((b) {
      if (b) {
        _pacmanModel.loadLevel(_currentLevel).then((b) {
          if (b) {
            _authenticateUser();
          } else {
            _err=true;
            _pacmanView.showErrorScreen();
          }
        });
      } else {
        _err=true;
        _pacmanView.showErrorScreen();
      }
    });
    _pacmanView.startNext.onClick.listen((_) {
      _pacmanModel.loadLevel(_currentLevel).whenComplete(() => _startGame());
    });
  }

  Future _authenticateUser() async {
    _gamekey = new GameKeyClient(
        LevelLoader.gamekeyHost,
        LevelLoader.gamekeyPort,
        LevelLoader.gamekeyID,
        LevelLoader.gamekeySecret);
    await _gamekey.authenticate();
    if (_pacmanView.mql.matches) {
      _pacmanView.showMobile();
    }
    if(_err==false){
    _pacmanView.showGame();
    _pacmanView.hideLoading();
    _startGame();
    }
  }

  //start new game
  void _startGame() {
    if (_gamekey._available) {
      _pacmanView.updateMessages("Gamekey available", true);
    } else {
      _pacmanView.updateMessages("Gamekey unavailable", false);
    }
    if (_currentLevel > 1) {
      _pacmanView.hideOverlay();
    }
    if (_currentLevel == _maxLevel) {
      _pacmanView.hideNextLevel();
    }
    var labyrinth = _pacmanModel.getMap();
      _createTable(labyrinth);

    _refreshLabyrinth(labyrinth);
    //also use continueGame to initalise Timer
    _continueGame();

    if (_pacmanView.mql.matches) {
      if (_up != null) _up.cancel();
      _up = _pacmanView.mobileUp.onClick.listen((_) {
        _pacmanModel.moveUp();
      });
      if (_down != null) _down.cancel();
      _down = _pacmanView.mobileDown.onClick.listen((_) {
        _pacmanModel.moveDown();
      });
      if (_left != null) _left.cancel();
      _left = _pacmanView.mobileLeft.onClick.listen((_) {
        _pacmanModel.moveLeft();
      });
      if (_right != null) _right.cancel();
      _right = _pacmanView.mobileRight.onClick.listen((_) {
        _pacmanModel.moveRight();
      });
      if (_pause != null) _pause.cancel();
      _pause = _pacmanView.mobilePause.onClick.listen((_) {
        if(_paused){
          _pacmanView.hidePause();
          _continueGame();
        }else{
          _pacmanView.showPause();
          _paused=true;
          _stopGame();
        }
      });

    } else {
      if (_keyListener != null) _keyListener.cancel();
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
          case KeyCode.SPACE:
            if (_paused) {
              _pacmanView.hidePause();
              _continueGame();
            } else {
              _pacmanView.showPause();
              _paused = true;
              _stopGame();
            }
        }
      });
    }
  }
  void _continueGame(){
    _paused=false;
    if (_timer != null) _timer.cancel();
    _timer = new Timer.periodic(speed, (_) => _pacmanModel.triggerFrame());
  }
  //create the table in the view
  void _createTable(List<List<Types>> l) {
    _pacmanView.initTable(l);
  }

  //load the current game elements and graphis into the table
  void _refreshLabyrinth(List<List<Types>> l) {
    _pacmanView.labyrinthFill(l);
  }

  //updates the current view
  void updateGameStatus() {
    _updateScore();
    _updateLevel();
    _updateLives();
    _updatePowerUpTime();
    var _labyrinth = _pacmanModel.getMap();
    _refreshLabyrinth(_labyrinth);
    _gameOver(_pacmanModel.gameEnd);
    _gameWon(_pacmanModel.gameVic);
  }
  void toggleErrorScreen(){
    _err = true;
    _pacmanView.showErrorScreen();
  }
  void loadBonusLevel() {
    _achievedScore += _pacmanModel.score;
    _stopGame();
    _pacmanModel.newGame();
    _pacmanModel.loadLevel(0).whenComplete(() => _startGame());
  }
  //ends the game, lost
  void _gameOver(bool b) {
    if (b) {
      _stopGame();
      _pacmanView.hideNextLevel();
      _pacmanView.updateOverlay("GAME OVER");
      if (_gamekey._available) {
        _pacmanView.showHighscore();
        _pacmanView.savename.onClick.listen((_) {
          _saveScore();
        });
      }
    }
  }

  void _saveScore() {
    if (_gamekey._available) {
      _achievedScore += _pacmanModel.score;
      _gamekey._addScore(_pacmanView.user, _achievedScore).then((b) {
        _gamekey.getTop10().then((scores) {
          _pacmanView.showTop10(scores, _achievedScore);
        });
      });
    }
  }

  //ends the game, won
  void _gameWon(bool b) {
    if (b) {
      _stopGame();
      _achievedScore += _pacmanModel.score;
      _pacmanView.updateOverlay("STAGE CLEARED");
      if (_currentLevel < _maxLevel) {
        _pacmanModel.newGame();
        _currentLevel++;
      } else {
        if (_gamekey._available) {
          _pacmanView.showHighscore();
          _pacmanView.savename.onClick.listen((_) {
            _saveScore();
          });}
      }
    }
  }

  //stops interaction
  void _stopGame() {
    if(!_paused) {
      if (_pacmanView.mql.matches) {
        _up.cancel();
        _down.cancel();
        _left.cancel();
        _right.cancel();
      } else {
        _keyListener.cancel();
      }
    }
    _timer.cancel();
  }

  //set the direction for pacman to choose the right graphic
  void setPacmanDir(Directions p) {
    this._pacmanDir = p;
  }

  //let the view display the current score
  void _updateScore() {
    _pacmanView.updateScore(_pacmanModel.score);
  }

  void _updateLevel() {
    _pacmanView.updateLevel(_pacmanModel.level);
  }

  void _updateLives() {
    _pacmanView.updateLives(_pacmanModel.lives);
  }

  void _updatePowerUpTime() {
    _pacmanView.updatePowerUpTime(_pacmanModel.counter);}
}
