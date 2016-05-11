part of pacmanLib;

class PacmanGameController{

  PacmanGameModel _pacmanModel;
  PacmanGameView _pacmanView;

  var _keyListener;

  PacmanGameController() {

    _pacmanModel = new PacmanGameModel();
    _pacmanView = new PacmanGameView(this);

    _pacmanView.startButton.onClick.listen((_) {_pacmanModel.loadLevel(1);  startGame();});
  }


  void startGame() {
    _pacmanView.showGameview();

    var labyrinth = _pacmanModel.getStaticMap();

    refreshField(labyrinth);
    refreshField4(labyrinth);
    labyrinth = _pacmanModel.getDynamicMap();

    refreshField2(labyrinth);

    labyrinth = _pacmanModel.getItemMap();

    refreshField3(labyrinth);


    _keyListener = window.onKeyDown.listen((KeyboardEvent ev) {
      switch (ev.keyCode) {
        case KeyCode.LEFT:  _pacmanModel.moveLeft(); break;
        case KeyCode.RIGHT:  _pacmanModel.moveRight(); break;
        case KeyCode.DOWN: _pacmanModel.moveDown(); break;
        case KeyCode.UP: _pacmanModel.moveUp(); break;
      }
    });

  }

  void refreshField(List<List<Statics>> l ) {
      _pacmanView.updateListen(l);
  }
  void refreshField2(List<List<Dynamics>> l) {
    _pacmanView._labyrinthAddDynamic(l);
  }
  void refreshField3(List<List<Items>> l) {
    _pacmanView._labyrinthAddItems(l);
  }
  void refreshField4(List<List<Statics>> l) {
    _pacmanView._labyrinthAddStatics(l);
  }
  void updateGameStatus() {

  }
  void updateListen() {

  }
  void updateScore() {

  }
}