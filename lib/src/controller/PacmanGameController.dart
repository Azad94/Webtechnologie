part of pacmanLib;

//the refreshrate of the view
const speed = const Duration(milliseconds: 500);

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
    refreshField2(labyrinth);

    _timer = new Timer.periodic(speed, (_) {_pacmanModel.triggerFrame(); });

    _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _pacmanModel.moveLeft(); break;
        case KeyCode.RIGHT:  _pacmanModel.moveRight(); break;
        case KeyCode.DOWN: _pacmanModel.moveDown(); break;
        case KeyCode.UP: _pacmanModel.moveUp(); break;
      }
    });

  }

  //let the view create the table
  void initField(List<List<Types>> l ) {
      _pacmanView.initField(l);
  }
  //let the view load the current game elements and graphis into the table
  void refreshField2(List<List<Types>> l) {
    _pacmanView._labyrinthFill(l);
    //_pacmanView.updateMessages(l[0].toString());
  }
  //updates the current view
  void updateGameStatus() {
    updateScore();
    updateLevel();
    updateLives();
    var labyrinth = _pacmanModel.getMap();
    refreshField2(labyrinth);
  }
  void updateListen() {

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