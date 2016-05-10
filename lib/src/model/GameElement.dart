part of pacmanLib;

abstract class GameElement {
  int _x,_y;
  bool _collisionPlayer;
  bool _collisionGhost;

  GameElement(this._x, this._y, this._collisionPlayer, this._collisionGhost);
}