part of pacmanLib;

class Level {
  num _sizeX;
  num _sizeY;
  List<List<Tile>> _tiles = new List<List<Tile>>();

  Level(String environmentCode, num sizeX, num sizeY) {
    this._sizeX = sizeX;
    this._sizeY = sizeY;
    initTiles();
    createObjects(environmentCode);
  }

  bool checkCollision(int x, int y) => false;

  /**
   * Register a [GameElement] on a new position.
   * xOld and yOld is the old position and xNew and yNew the new one. g is a reference on the moving objekt.
   */
  void registerElement(int xOld, int yOld, int xNew, int yNew, GameElement g) {
    if (GameElement is Pacman) {
      _tiles[yOld][xOld]._pacman = null;
      _tiles[yNew][xNew]._pacman = g;
    }
    if (GameElement is Ghost) {
      _tiles[yOld][xOld].ghosts.remove(g);
      _tiles[yNew][xNew].ghosts.add(g);
    }
  }

  /**
   * Creates a List<List> with all static [GameElement] and return it
   */
  List<List<Statics>> getStaticMap() {
    List<List<Statics>> ret = new List<List<Statics>>();
    for (int y = 0; y < _sizeY; y++) {
      ret.add(new List());
      for (int x = 0; x < _sizeX; x++) {
        // no environment
        if (_tiles[y][x]._environment == null) {
          ret[y].add(Statics.NOTHING);
        }
        // is Wall
        else if (_tiles[y][x]._environment._door == false &&
            _tiles[y][x]._environment._collisionPlayer == true)
          ret[y].add(Statics.WALL);
        // is Floor
        else if (_tiles[y][x]._environment._door == false)
          ret[y].add(Statics.FLOOR);
        // is door
        else
          ret[y].add(Statics.DOOR);
      }
    }
    return ret;
  }

  List<List<Dynamics>> getDynamicMap() {
    List<List<Dynamics>> ret = new List<List<Dynamics>>();
    for (int y = 0; y < _sizeY; y++) {
      ret.add(new List<Dynamics>());
      for (int x = 0; x < _sizeX; x++) {
        /*
         * if more ghosts of pacman and ghosts on the same field the following priority are used:
         * if pacman on a field, only pacman is returned
         * if two or more ghost on one field, only the first ghost in list is returned
         */
        // is pacman
        if (_tiles[y][x]._pacman != null)
          ret[y].add(Dynamics.PACMAN);
        // is a ghost
        else if (_tiles[y][x].ghosts.length != 0) {
          // is ghost Bashful
          if (_tiles[y][x].ghosts[0] is Bashful)
            ret[y].add(Dynamics.BASHFUL);
          // is ghost Shadow
          else if (_tiles[y][x].ghosts[0] is Shadow)
            ret[y].add(Dynamics.SHADOW);
          // is ghost Speedy
          else if (_tiles[y][x].ghosts[0] is Speedy)
            ret[y].add(Dynamics.SPEEDY);
          //  is ghost Pokey
          else if (_tiles[y][x].ghosts[0] is Pokey) ret[y].add(Dynamics.POKEY);
        }
        // no dynamics
        else
          ret[y].add(Dynamics.NOTHING);
      }
    }
    return ret;
  }

  List<List<Items>> getIemMap() {
    List<List<Items>> ret = new List<List<Items>>();
    for (int y = 0; y < _sizeY; y++) {
      ret.add(new List<Items>());
      for (int x = 0; x < _sizeX; x++) {
        // no item
        if (_tiles[y][x]._item == null)
          ret[y].add(Items.NOTHING);
        // is pill
        else if (_tiles[y][x]._item is Pill)
          ret[y].add(Items.PILL);
        // is powerPill
        else if (_tiles[y][x]._item is PowerPill)
          ret[y].add(Items.POWERPILL);
        // is cherry
        else if (_tiles[y][x]._item is Cherry) ret[y].add(Items.CHERRY);
      }
    }
    return ret;
  }

  /*
  Helper methods
   */

  void createObjects(String environmentCode) {
    // Split string in lines
    List<String> lines = environmentCode.split(LevelLoader.NEWLINE);
    // compatible to size?
    if (lines.length != _sizeY) {
      // TODO log
      return;
    }
    for (int y = 0; y < _sizeY; y++) {
      String line = lines[y];
      for (int x = 0; x < _sizeX; x++) {
        switch (line[x]) {
          case LevelLoader.WALL:
            _tiles[y][x]._environment =
                new Environment(x, y, true, true, false, false);
            break;

          // TODO score
          case LevelLoader.PILL:
            _tiles[y][x]._item = new Pill(x, y, true, false, true, 0);
            break;

          case LevelLoader.POWERPILL:
            _tiles[y][x]._item = new PowerPill(x, y, true, false, true, 0);
            break;

          case LevelLoader.CHERRY:
            _tiles[y][x]._item = new Cherry(x, y, true, false, true, 0);
            break;

          case LevelLoader.GHOST:
            _tiles[y][x]
                .ghosts
                .add(new Bashful(x, y, false, false)); // TODO create all Ghosts
            break;

          case LevelLoader.PACMAN:
            _tiles[y][x]._pacman =
                new Pacman(x, y, false, true, 1); // TODO lives
            break;

          case LevelLoader.DOOR:
            _tiles[y][x]._environment =
                new Environment(x, y, true, false, false, true);
            break;

          default:
            break;
        }
      }
    }
  }

  void initTiles() {
    for (int i = 0; i < _sizeY; i++) {
      List<Tile> list = new List();
      for (int j = 0; j < _sizeX; j++) {
        list.add(new Tile());
      }
      _tiles.add(list);
    }
  }
}
