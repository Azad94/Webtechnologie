part of pacmanLib;

class Blinky extends Ghost {

  Blinky(int x, int y, bool collPlayer, bool collGhost, Level l)
      : super(x, y, collPlayer, collGhost, l);

  int _targetX=1;
  int _targetY=1;

  int _doorTargetX = 14;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 2;

  int _alternativeTargetX = 28;
  int _alternativeTargetY = 17;

  int _directionsChanged = 0;

/*  List getRouteRecursive;

//  void calcRoute() {
  //gibt die bisher beste Liste zurück
  List<Directions> getRoute() {
    List<Directions> route = new List();
    return getRouteRecursive(route, _x, _y);
  }

  List<Directions> getRouteRecursive(List<Directions> prev, int routeX,
      int routeY) {
    if (prev.length > 10) {
      return prev;
    }

    List<Directions> left;
    List<Directions> up;
    List<Directions> right;
    List<Directions> down;
    List<Directions> best = new List();

    // requires better interface to differentiate collisions from finding pacman
    if ((prev.length == 0 || prev.last != Directions.RIGHT) &&
        !_level.checkCollision(routeX ++, routeY, this)) {
      if (routeX ++ == _targetX && routeY == _targetY) {
        prev.add(Directions.RIGHT);
        right = prev;
      } else {
        prev.add(Directions.RIGHT);
        right = getRouteRecursive(prev, routeX ++, routeY);
      }
    }
    if ((prev.length == 0 || prev.last != Directions.UP) &&
        !_level.checkCollision(routeX, routeY ++, this)) {
      if (routeX == _targetX && routeY ++ == _targetY) {
        prev.add(Directions.UP);
        up = prev;
      } else {
        prev.add(Directions.UP);
        up = getRouteRecursive(prev, routeX, routeY ++);
      }
    }
    if ((prev.length == 0 || prev.last != Directions.LEFT) &&
        !_level.checkCollision(routeX --, routeY, this)) {
      if (routeX -- == _targetX && routeY == _targetY) {
        prev.add(Directions.LEFT);
        left = prev;
      } else {
        prev.add(Directions.LEFT);
        left = getRouteRecursive(prev, routeX --, routeY);
      }
    }
    if ((prev.length == 0 || prev.last != Directions.DOWN) &&
        !_level.checkCollision(routeX, routeY --, this)) {
      if (routeX ++ == _targetX && routeY == _targetY) {
        prev.add(Directions.DOWN);
        down = prev;
      } else {
        prev.add(Directions.DOWN);
        down = getRouteRecursive(prev, routeX, routeY --);
      }
    }
//Vergleich der Listen um den kürzesten Weg zu finden
    if (left != null) {
      best = left;
    }
    if (up != null && (best.length == 0 || up.length < best.length)) {
      best = up;
    }
    if (right != null && (best.length == 0 || right.length < best.length)) {
      best = right;
    }
    if (down != null && (best.length == 0 || down.length < best.length)) {
      best = down;
    }
    return best;
  }
//}

  // @override
  // bool getNextMove(_x, _y, _targetX, _targetY, this) {  }


*/


  void move() {
 //   if(_x == _targetX && _y == _targetY) _directionsChanged++;

 /*   switch(_directionsChanged)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        break;

      case 1:
        _targetX = _scatterTargetX;
        _targetY = _scatterTargetY;
        break;

      case 2:
        _targetX = _alternativeTargetX;
        _targetY = _alternativeTargetY;
        break;

      case 3:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        _directionsChanged = 0;
        break;
    }*/

    switch(getNextMove(_x, _y, 30, 17, this))
    {
     case Directions.UP:
 //      if (!_level.checkCollision(_x, _y - 1, this))
         _level.registerElement(_x, _y, _x, --_y, this);
       break;
     case Directions.DOWN:
 //        if (!_level.checkCollision(_x, _y + 1, this))
         _level.registerElement(_x, _y, _x, ++_y, this);
       break;
     case Directions.LEFT:
 //      if (!_level.checkCollision(_x - 1, _y, this))
         _level.registerElement(_x, _y, --_x, _y, this);
       break;
     case Directions.RIGHT:
  //     if (!_level.checkCollision(_x + 1, _y, this))
         _level.registerElement(_x, _y, ++_x, _y, this);
       break;
      case Directions.NOTHING:
        _level.registerElement(_x,_y,1,1,this);
        break;
   }
  }

  void eatableMode() {
  }
}