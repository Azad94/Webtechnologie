part of pacmanLib;

abstract class Ghost {

  double _speed;
  boolean _eatable;
  int _start_;
  boolean _invisble;
  int _bustedModeTimer;

  void move(){}
  void setEatable(boolean eatable){}
}