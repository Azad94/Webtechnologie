part of pacmanLib;

class Tile {

  Environment _environment;
  Item _item;
  Pacman _pacman;
  List<Ghost> _ghosts = new List();

  Environment get enviornment => _environment;
  void set enviornment(Environment enviornment) {
    this._environment = enviornment;
  }

  Item get item => _item;
  void set item (Item item) {
    this._item = item;
  }

  Pacman get pacman => _pacman;
  void set pacman (Pacman pacman) {
    this._pacman = pacman;
  }

  List<Ghost> get ghosts => _ghosts;
  void set ghosts (List<Ghost> ghosts) {
    this._ghosts = ghosts;
  }
}