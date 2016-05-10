part of pacmanLib;

class Level {
  int _sizeX;
  int _sizeY;
  int _lives;
  num _scorePill;
  num _scoreCherry;
  num _scorePowerPill;

  /**
   * brain for collision detection
   * Only check collision for ghost when pacman is already moved.
   */
  bool _pacmanMoved = false;

  /**
   * brain for collision detection
   * if every ghost has been moved reset brain
   */
  int _ghostMoved = 0;

  List<List<Tile>> _tiles = new List<List<Tile>>();
  PacmanGameModel _model;

  /**
   * Creates a level by given parameters
   */
  Level(String environmentCode, num sizeX, num sizeY, int lives, num scorePill,
      num scoreCherry, num scorePowerPill, PacmanGameModel model) {
    this._sizeX = sizeX;
    this._sizeY = sizeY;
    this._model = model;
    this._lives = lives;
    this._scorePill = scorePill;
    this._scoreCherry = scoreCherry;
    this._scorePowerPill = scorePowerPill;
    initTiles();
    createObjects(environmentCode);
  }

  /**
   * checks if the given [GameElement] collides with another [GameElement]
   * return true if the object collides with another one, else false
   */
  bool checkCollision(int x, int y, GameElement g) {
    // no Statics
    if (_tiles[y][x]._environment == null) return false;
    // ghosts collides
    if (_tiles[y][x]._environment._collisionGhost == true && g is Ghost)
      return true;
    // pacman collides
    if (_tiles[y][x]._environment._collisionPlayer == true && g is Pacman)
      return true;
    // no collision
    return false;
  }

  /**
   * Register a [GameElement] on a new position.
   * xOld and yOld is the old position and xNew and yNew the new one. g is a reference on the moving objekt.
   */
  void registerElement(int xOld, int yOld, int xNew, int yNew, GameElement g) {
    // pacman chance position
    if (g is Pacman) {
      _pacmanMoved = true;
      _tiles[yOld][xOld]._pacman = null;
      _tiles[yNew][xNew]._pacman = g;
      this.collisionDetectionItem(xNew, yNew);
      this.collisionDetectionGhost(xNew, yNew);
    }
    // ghost chance position
    if (g is Ghost) {
      _ghostMoved++;
      _tiles[yOld][xOld].ghosts.remove(g);
      _tiles[yNew][xNew].ghosts.add(g);
      this.collisionDetectionGhost(xNew, yNew);
    }
    // every Dynamic GameElement had been moved
    // reset brain
    if(_pacmanMoved && _ghostMoved == 4) {
      _pacmanMoved = false;
      _ghostMoved = 0;
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

  /**
   * Creates a List<List> with all Dynamic [GameElement] and return it
   */
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
          if (_tiles[y][x].ghosts[0] is Inky)
            ret[y].add(Dynamics.INKY);
          // is ghost Shadow
          else if (_tiles[y][x].ghosts[0] is Blinky)
            ret[y].add(Dynamics.BLINKY);
          // is ghost Speedy
          else if (_tiles[y][x].ghosts[0] is Clyde)
            ret[y].add(Dynamics.CLYDE);
          //  is ghost Pokey
          else if (_tiles[y][x].ghosts[0] is Pinky) ret[y].add(Dynamics.PINKY);
        }
        // no dynamics
        else
          ret[y].add(Dynamics.NOTHING);
      }
    }
    return ret;
  }

  /**
   * Creates a List<List> with all Items [GameElement] and return it
   */
  List<List<Items>> getIemMap() {
    List<List<Items>> ret = new List<List<Items>>();
    for (int y = 0; y < _sizeY; y++) {
      ret.add(new List<Items>());
      for (int x = 0; x < _sizeX; x++) {
        // no item
        if (_tiles[y][x]._item == null)
          ret[y].add(Items.NOTHING);
        // is pill
        else if (_tiles[y][x]._item is Pill && _tiles[y][x]._item._visible)
          ret[y].add(Items.PILL);
        // is powerPill
        else if (_tiles[y][x]._item is PowerPill && _tiles[y][x]._item._visible)
          ret[y].add(Items.POWERPILL);
        // is cherry
        else if (_tiles[y][x]._item is Cherry && _tiles[y][x]._item._visible)
          ret[y].add(Items.CHERRY);
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

          case LevelLoader.PILL:
            _tiles[y][x]._item = new Pill(x, y, true, false, true, _scorePill, _model);
            break;

          case LevelLoader.POWERPILL:
            _tiles[y][x]._item =
            new PowerPill(x, y, true, false, true, _scorePill, _model);
            break;

          case LevelLoader.CHERRY:
            _tiles[y][x]._item =
            new Cherry(x, y, true, false, true, _scoreCherry, _model);
            break;

          case LevelLoader.INKY:
            _tiles[y][x].ghosts.add(new Inky(x, y, false, false, this));
            break;

          case LevelLoader.PINKY:
            _tiles[y][x].ghosts.add(new Pinky(x, y, false, false, this));
            break;

          case LevelLoader.CLYDE:
            _tiles[y][x].ghosts.add(new Clyde(x, y, false, false, this));
            break;

          case LevelLoader.BLINKY:
            _tiles[y][x].ghosts.add(new Blinky(x, y, false, false, this));
            break;

          case LevelLoader.PACMAN:
            final p = new Pacman(x, y, false, true, _lives, this, _model);
            _tiles[y][x]._pacman = p;
            _model.registerGameElement(p);
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

  void collisionDetectionItem(int x, int y) {
    // no collision possible, pacman is not here
    if(_tiles[y][x]._pacman == null) return;
    // pacman collides with item
    if(_tiles[y][x]._item != null) {
      _tiles[y][x]._item.pickUp();
    }
  }

  void collisionDetectionGhost(int x, int y) {
    // pacman will move later
    if(!_pacmanMoved) return;
    // pacman is already moved and ghost collides with pacman
    if(_tiles[y][x]._pacman != null && _tiles[y][x].ghosts.length != 0) {
      _tiles[y][x]._pacman.decreaseLife();
    }
  }
}