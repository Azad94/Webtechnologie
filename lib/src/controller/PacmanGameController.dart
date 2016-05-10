part of pacmanLib;

class PacmanGameController{

  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;

  var _keyListener;

  PacmanGameController() {

    _pacmanModel = new PacmanGameModel();
    _pacmanView = new PacmanGameView(this);

    _pacmanView.startButton.onClick.listen((_) { _pacmanModel.loadLevel(1); startGame();});
  }


  void startGame() {
    _pacmanView.showGameview();

    var labyrinth = _pacmanModel.getStaticMap();

    refreshField(labyrinth);


    _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _pacmanModel.moveLeft(); break;
        case KeyCode.RIGHT:  _pacmanModel.moveRight(); break;
        case KeyCode.DOWN: _pacmanModel.moveDown(); break;
        case KeyCode.UP: _pacmanModel.moveUp(); break;
      }
    });

  }

  void refreshField(List<List<Tile>> l ) {
      _pacmanView.updateListen(l);
  }
  void updateGameStatus() {

  }
  void updateListen() {

  }
  void updateScore() {

  }
}