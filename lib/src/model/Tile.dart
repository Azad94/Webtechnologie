part of pacmanLib;

class Tile {
  Environment _environment;
  Item _item;
  Pacman _pacman;
  List<Ghost> ghosts = new List();
}