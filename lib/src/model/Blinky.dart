part of pacmanLib;

class Blinky extends Ghost {

  Blinky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);


//  int targetX=7;
//  int targetY=1;

  int routeX=11;
  int routeY=10;

/*  int _doorTargetX = 14;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 2;

  int _alternativeTargetX = 28;
  int _alternativeTargetY = 17;

  int _directionsChanged = 0;
*/

  //gibt die bisher beste Liste zurück
  List<Directions> getRoute() {
    List<Directions> route = new List();
    return getRouteRecursive(route, _x, _y);
  }


  List<Directions> getRouteRecursive(List<Directions> prev, routeX, routeY) {


    if (prev.length > 5) {
      return prev;
    }

    List<Directions> left;
    List<Directions> up;
    List<Directions> right;
    List<Directions> down;
    List<Directions> nothing;
    List<Directions> best = new List();


    // requires better interface to differentiate collisions from finding pacman
    //Abbruchbedingungen für Abfrage fehlt
    if (!_level.checkCollision(routeX++, routeY, this) && (routeX < 1) ) {
        prev.add(Directions.RIGHT);
        right = getRouteRecursive(prev, ++routeX , routeY);
    }
    if (!_level.checkCollision(routeX--, routeY, this) && (routeX > 1)) {
        prev.add(Directions.LEFT);
        left = getRouteRecursive(prev, --routeX, routeY);
    }
    if (!_level.checkCollision(routeX, routeY-1, this) && (routeY > 1)) {
      prev.add(Directions.UP);
      up = getRouteRecursive(prev, routeX, --routeY);
    }
    if (!_level.checkCollision(routeX, routeY+1, this) && (routeY < 1)) {
      prev.add(Directions.DOWN);
      down = getRouteRecursive(prev, routeX, ++routeY);
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




  // @override

//NextDirection should be the first element from best


  void move() {
  // nextDirection = getRoute().first;
    print(getRoute());
   // print(nextDirection);

 //   var route = ['apples', 'pears', 'oranges'];

 /*   var iterator = fruits.iterator;
    while (iterator.moveNext()) {
      var fruit = iterator.current;
      print(fruit);}*/

  var iterator = getRoute().iterator;
   while (iterator.moveNext()) {
     nextDirection = iterator.current;
      print(nextDirection);


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
//getNextMove(_x, _y, _targetX, _targetY, this)
      switch(nextDirection) {
        case Directions.UP:
//          if (!_level.checkCollision(_x, _y --, this))
            _level.registerElement(_x, _y, _x, --_y, this);
          break;
        case Directions.DOWN:
//          if (!_level.checkCollision(_x, _y ++, this))
            _level.registerElement(_x, _y, _x, ++_y, this);
          break;
        case Directions.LEFT:
//          if (!_level.checkCollision(_x --, _y, this))
            _level.registerElement(_x, _y, _x--, _y, this);
          break;
        case Directions.RIGHT:
//          if (!_level.checkCollision(_x ++, _y, this))
            _level.registerElement(_x, _y, _x++, _y, this);
          break;
        default:
          break;
      }
      }
  }

  void eatableMode() {
  }
}