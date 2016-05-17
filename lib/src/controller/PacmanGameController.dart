part of pacmanLib;

//the refreshrate of the view
const speed = const Duration(milliseconds: 200);

class PacmanGameController{

  //instances of PacmanGameModel and PacmanGameView
  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;

  //the current Direction of Pacman
  Directions pacmanDir = Directions.RIGHT;

  //keyListener for User interaction and timer for the refreshrate
  var _keyListener;
  Timer _timer;

  //constructor
  PacmanGameController() {

    _pacmanModel = new PacmanGameModel(this);
    _pacmanView = new PacmanGameView(this);

    _pacmanView.startButton.onClick.listen((_) {_pacmanModel.loadLevel(1);  startGame();});
  }


  //starts a new game
  void startGame() {
    _pacmanView.showGameview();

    var labyrinth = _pacmanModel.getMap();
    initField(labyrinth);
    refreshLabyrinth(labyrinth);

    _timer = new Timer.periodic(speed, (_) {_pacmanModel.triggerFrame(); });

    _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
      ev.preventDefault();
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _pacmanModel.moveLeft(); break;
        case KeyCode.RIGHT:  _pacmanModel.moveRight(); break;
        case KeyCode.DOWN: _pacmanModel.moveDown(); break;
        case KeyCode.UP: _pacmanModel.moveUp(); break;
      }
    });

  }

  //create the table in the view
  void initField(List<List<Types>> l ) {
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
    if(b){
      stopGame();
      _pacmanView.updateOverlay("GAME OVER");
    }
  }
  //ends the game, won
  void gameWon(bool b) {
    if(b) {
      stopGame();
      _pacmanView.updateOverlay("STAGE CLEARED");
      _pacmanView._nextLevel.classes.toggle('show');
    }
  }
  //stops interaction
  void stopGame(){
    _keyListener.cancel();
    _timer.cancel();
  }

  //set the direction for pacman to choose the right graphic
  void setPacmanDir(Directions p){
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
  void _updateMessage(String str) {
    _pacmanView.updateMessages(str);
  }
}