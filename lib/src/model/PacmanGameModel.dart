part of pacman;

class PacmanGameModel{


  bool pause = false;
  bool gameOver = false;
  int size = 0;
  //to prevent error warnings for the constructor
  int x, y;
  Controller controller;
  Pacman pacman;



  //gets the controller as param
  PacmanGameModel(this.controller);

  PacmanGame(int x, int y){
    this.x = x;
    this.y = y;
  }

  getGameOver bool(){ return (pacman.getLife()) == 0 ? true : false;}

  moveUp(){

  }

  moveDown(){

  }

  moveLeft(){

  }

  moveRight(){

  }

  pauseGame(){

  }

  moveGhost(){

  }

  getEnvironmentMap(){

  }

  getDynamicMap(){

  }

  getItemMap(){
    
  }
}