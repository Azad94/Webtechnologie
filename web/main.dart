// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:Webtechnologie/pacmanLib.dart';

void main() {
  PacmanGameModel model = new PacmanGameModel();
  model.loadLevel(0);
  querySelector('#output').text = model.getStaticMap().toString();
}
