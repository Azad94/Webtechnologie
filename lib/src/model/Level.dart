part of pacmanLib;

class Level {
  int _levelNum;

  Level(this._levelNum);

  bool checkCollision(int x, int y) => false;

  List<List<Statics>> getStaticMap() => null;

  List<List<Dynamics>> getDynamicMap() => null;

  List<List<Items>> getIemMap() => null;
}
