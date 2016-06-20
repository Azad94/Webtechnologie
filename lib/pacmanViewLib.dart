library pacmanViewLib;

import 'dart:html';
import 'package:Webtechnologie/pacmanModelLib.dart';

part 'src/view/PacmanGameView.dart';

/**
 * the paths as const for the different graphics
 */
/**
 * enviornment resources
 */
const String _wall =
    "background-image:url(../web/resc/enviornment/wall32.png);";
const String _door =
    "background-image:url(../web/resc/enviornment/door32.png);";
const String _wall16 =
    "background-image:url(../web/resc/16px/enviornment/wall16.png);";
const String _door16 =
    "background-image:url(../web/resc/16px/enviornment/door16.png);";
/**
 * ghost normal state resources
 */
/**
 * Blinky
 */
const String _blinky_r =
    "background-image:url(../web/resc/ghosts/blinky/blinky_r32.png);";
const String _blinky_l =
    "background-image:url(../web/resc/ghosts/blinky/blinky_l32.png);";
const String _blinky_u =
    "background-image:url(../web/resc/ghosts/blinky/blinky_t32.png);";
const String _blinky_d =
    "background-image:url(../web/resc/ghosts/blinky/blinky_d32.png);";
const String _blinky_r16 =
    "background-image:url(../web/resc/16px/ghosts/blinky/blinky_r16.png);";
const String _blinky_l16 =
    "background-image:url(../web/resc/16px/ghosts/blinky/blinky_l16.png);";
const String _blinky_u16 =
    "background-image:url(../web/resc/16px/ghosts/blinky/blinky_t16.png);";
const String _blinky_d16 =
    "background-image:url(../web/resc/16px/ghosts/blinky/blinky_d16.png);";
/**
 * Pinky
 */
const String _pinky_r =
    "background-image:url(../web/resc/ghosts/pinky/pinky_r32.png);";
const String _pinky_l =
    "background-image:url(../web/resc/ghosts/pinky/pinky_l32.png);";
const String _pinky_u =
    "background-image:url(../web/resc/ghosts/pinky/pinky_t32.png);";
const String _pinky_d =
    "background-image:url(../web/resc/ghosts/pinky/pinky_d32.png);";
const String _pinky_r16 =
    "background-image:url(../web/resc/16px/ghosts/pinky/pinky_r16.png);";
const String _pinky_l16 =
    "background-image:url(../web/resc/16px/ghosts/pinky/pinky_l16.png);";
const String _pinky_u16 =
    "background-image:url(../web/resc/16px/ghosts/pinky/pinky_t16.png);";
const String _pinky_d16 =
    "background-image:url(../web/resc/16px/ghosts/pinky/pinky_d16.png);";
/**
 * Inky
 */
const String _inky_r =
    "background-image:url(../web/resc/ghosts/inky/inky_r32.png);";
const String _inky_l =
    "background-image:url(../web/resc/ghosts/inky/inky_l32.png);";
const String _inky_u =
    "background-image:url(../web/resc/ghosts/inky/inky_t32.png);";
const String _inky_d =
    "background-image:url(../web/resc/ghosts/inky/inky_d32.png);";
const String _inky_r16 =
    "background-image:url(../web/resc/16px/ghosts/inky/inky_r16.png);";
const String _inky_l16 =
    "background-image:url(../web/resc/16px/ghosts/inky/inky_l16.png);";
const String _inky_u16 =
    "background-image:url(../web/resc/16px/ghosts/inky/inky_t16.png);";
const String _inky_d16 =
    "background-image:url(../web/resc/16px/ghosts/inky/inky_d16.png);";
/**
 * Clyde
 */
const String _clyde_r =
    "background-image:url(../web/resc/ghosts/clyde/clyde_r32.png);";
const String _clyde_l =
    "background-image:url(../web/resc/ghosts/clyde/clyde_l32.png);";
const String _clyde_u =
    "background-image:url(../web/resc/ghosts/clyde/clyde_t32.png);";
const String _clyde_d =
    "background-image:url(../web/resc/ghosts/clyde/clyde_d32.png);";
const String _clyde_r16 =
    "background-image:url(../web/resc/16px/ghosts/clyde/clyde_r16.png);";
const String _clyde_l16 =
    "background-image:url(../web/resc/16px/ghosts/clyde/clyde_l16.png);";
const String _clyde_u16 =
    "background-image:url(../web/resc/16px/ghosts/clyde/clyde_t16.png);";
const String _clyde_d16 =
    "background-image:url(../web/resc/16px/ghosts/clyde/clyde_d16.png);";
/**
 * ghost scared state resources
 */
const String _scared_r =
    "background-image:url(../web/resc/ghosts/scared/a_scaredghost_r.gif);";
const String _scared_l =
    "background-image:url(../web/resc/ghosts/scared/a_scaredghost_l.gif);";
const String _scared_u =
    "background-image:url(../web/resc/ghosts/scared/a_scaredghost_t.gif);";
const String _scared_d =
    "background-image:url(../web/resc/ghosts/scared/a_scaredghost_d.gif);";
const String _scared_r16 =
    "background-image:url(../web/resc/16px/ghosts/scared/a_scaredghost_r16.gif);";
const String _scared_l16 =
    "background-image:url(../web/resc/16px/ghosts/scared/a_scaredghost_l16.gif);";
const String _scared_u16 =
    "background-image:url(../web/resc/16px/ghosts/scared/a_scaredghost_t16.gif);";
const String _scared_d16 =
    "background-image:url(../web/resc/16px/ghosts/scared/a_scaredghost_d16.gif);";
/**
 * Pacman normal state resources
 */
const String _pacman_r =
    "background-image:url(../web/resc/pacman/pacman_r32.gif);";
const String _pacman_l =
    "background-image:url(../web/resc/pacman/pacman_l32.gif);";
const String _pacman_u =
    "background-image:url(../web/resc/pacman/pacman_u32.gif);";
const String _pacman_d =
    "background-image:url(../web/resc/pacman/pacman_d32.gif);";
const String _pacman_r16 =
    "background-image:url(../web/resc/16px/pacman/pacman_r16.gif);";
const String _pacman_l16 =
    "background-image:url(../web/resc/16px/pacman/pacman_l16.gif);";
const String _pacman_u16 =
    "background-image:url(../web/resc/16px/pacman/pacman_u16.gif);";
const String _pacman_d16 =
    "background-image:url(../web/resc/16px/pacman/pacman_d16.gif);";

/**
 * items resources
 */
const String _pill = "background-image:url(../web/resc/items/pill32.png);";
const String _powerpill =
    "background-image:url(../web/resc/items/a_powerpill32.gif);";
const String _cherry =
    "background-image:url(../web/resc/items/a_cherry32.gif);";
const String _apple =
    "background-image:url(../web/resc/items/a_apple32.gif);";
const String _pill16 =
    "background-image:url(../web/resc/16px/items/pill16.png);";
const String _powerpill16 =
    "background-image:url(../web/resc/16px/items/a_powerpill16.gif);";
const String _cherry16 =
    "background-image:url(../web/resc/16px/items/a_cherry16.gif);";
const String _apple16 =
    "background-image:url(../web/resc/16px/items/a_apple16.gif);";
