part of pacmanLib;

const speed = const Duration(milliseconds: 500);

class PacmanGameController{

  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;

  var _keyListener;
  Timer _timer;

  PacmanGameController() {

    _pacmanModel = new PacmanGameModel();
    _pacmanView = new PacmanGameView(this);

    _pacmanView.startButton.onClick.listen((_) {_pacmanModel.loadLevel(1);  startGame();});
  }


  void startGame() {
    _pacmanView.showGameview();

    var labyrinth = _pacmanModel.getMap();
    initField(labyrinth);
    refreshField2(labyrinth);

    _timer = new Timer.periodic(speed, (_) => _pacmanModel.triggerFrame());

    _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _pacmanModel.moveLeft(); break;
        case KeyCode.RIGHT:  _pacmanModel.moveRight(); break;
        case KeyCode.DOWN: _pacmanModel.moveDown(); break;
        case KeyCode.UP: _pacmanModel.moveUp(); break;
      }
    });

  }

  void initField(List<List<Types>> l ) {
      _pacmanView.initField(l);
  }
  void refreshField2(List<List<Types>> l) {
    _pacmanView._labyrinthFill(l);
  }
  void updateGameStatus() {
    updateScore();
    var labyrinth = _pacmanModel.getMap();
    print(labyrinth[16]);
    refreshField2(labyrinth);
  }
  void updateListen() {

  }
  void updateScore() {
      _pacmanView.updateScore(_pacmanModel.getScore());
  }
}