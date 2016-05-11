part of pacmanLib;

class Environment extends GameElement {
  bool _itemPlaceable, _door;

  Environment(int x, int y, bool collPlayer, bool collGhost, bool itemPlaceable,
      bool door)
      : super(x, y, collPlayer, collGhost),
        this._itemPlaceable = itemPlaceable,
        this._door = door;

}