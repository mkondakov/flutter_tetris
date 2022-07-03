import 'dart:math';
import 'package:flutter/material.dart';

class TetrisFigure {
  TetrisFigure(
      {required this.figures,
      required this.position,
      required this.colorIndex}) {
    rotationIndex = Random().nextInt(figures.length);
    for (var i = 0; i < figures.length; i++) {
      for (var j = 0; j < figures[i].length; j++) {
        for (var k = 0; k < figures[i][j].length; k++) {
          if (figures[i][j][k] != 0) {
            figures[i][j][k] = colorIndex;
          }
        }
      }
    }
  }

  late int colorIndex;
  Point<int> position;
  List<List<List<int>>> figures;
  int rotationIndex = 0;

  TetrisFigure clone() {
    var tf = TetrisFigure(
        figures: figures, position: position, colorIndex: colorIndex);
    tf.rotationIndex = rotationIndex;
    tf.colorIndex = colorIndex;
    return tf;
  }

  static const List<List<List<List<int>>>> figuresList = [
    [
      [
        [1, 1],
        [1, 1],
      ],
    ],
    [
      [
        [0, 1, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
        [0, 1, 0, 0],
      ],
      [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
      ],
    ],
    [
      [
        [0, 0, 0],
        [0, 1, 1],
        [1, 1, 0],
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 0, 1],
      ],
    ],
    [
      [
        [0, 1, 0],
        [0, 1, 0],
        [1, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [0, 0, 1],
      ],
      [
        [1, 1, 0],
        [1, 0, 0],
        [1, 0, 0],
      ],
      [
        [0, 0, 0],
        [1, 0, 0],
        [1, 1, 1],
      ],
    ]
  ];

  static final List<Color> colors = <Color>[
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];
}

class TetrisModel {
  TetrisModel({required this.rowCount, required this.colCount})
      : gameState = List.generate(
            rowCount, (i) => List<int>.filled(colCount, 0),
            growable: false),
        gameStatePlusFigure = List.generate(
            rowCount, (i) => List<int>.filled(colCount, 0),
            growable: false) {}

  final int rowCount;
  final int colCount;

  List<List<int>> gameState;
  List<List<int>> gameStatePlusFigure;
  TetrisFigure? currentFigure;

  left() {
    if (currentFigure == null) return;
    var cf = currentFigure!;

    // if (cf.position.x <= 0) {
    //   return;
    // }

    var nf = cf.clone();
    nf.position = Point(cf.position.x - 1, cf.position.y);

    if (!_isStateCollideWith(nf)) {
      currentFigure = nf;
      gameStatePlusFigure = statePlusFigure();
    }
  }

  right() {
    if (currentFigure == null) return;
    var cf = currentFigure!;

    // if (cf.position.x >= colCount - cf.figure[0].length) {
    //   return;
    // }

    var nf = cf.clone();
    nf.position = Point(cf.position.x + 1, cf.position.y);

    if (!_isStateCollideWith(nf)) {
      currentFigure = nf;
      gameStatePlusFigure = statePlusFigure();
    }
  }

  bool downIfPossible() {
    if (currentFigure == null) return false;
    var cf = currentFigure!;

    // if (cf.position.y <= 0) {
    //   return false;
    // }

    var nf = cf.clone();
    nf.position = Point(cf.position.x, cf.position.y - 1);

    if (!_isStateCollideWith(nf)) {
      currentFigure = nf;
      gameStatePlusFigure = statePlusFigure();
    } else {
      return false;
    }
    return true;
  }

  rotate() {
    if (currentFigure == null) return;
    var cf = currentFigure!;

    for (var i = 0; i < 4; i++) {
      cf = _rotateByRotationIndexAndCreateNewFigure(cf);
      if (!_isStateCollideWith(cf)) {
        currentFigure = cf;
        gameStatePlusFigure = statePlusFigure();
        return;
      }
    }
  }

  TetrisFigure _rotateByRotationIndexAndCreateNewFigure(TetrisFigure f) {
    var fNew = f.clone();
    fNew.rotationIndex = (fNew.rotationIndex + 1) % fNew.figures.length;
    return fNew;
  }

  TetrisFigure _rotateClockwiseAndCreateNewFigure(TetrisFigure f) {
    var cfigure = f.figures[0];
    var y = cfigure.length;
    var x = cfigure[0].length;

    List<List<int>> nfigure = List.generate(
        cfigure[0].length, (i) => List<int>.filled(cfigure.length, 0),
        growable: false);

    for (var i = 0; i < y; i++) {
      for (var j = 0; j < x; j++) {
        nfigure[i][j] = cfigure[j][y - i - 1];
      }
    }

    var tf = f.clone();
    tf.figures[0] = nfigure;
    return tf;
  }

  bool _isStateCollideWith(TetrisFigure figure) {
    var f = figure.figures[figure.rotationIndex];
    var px = figure.position.x;
    var py = figure.position.y;

    for (var i = 0; i < f.length; i++) {
      for (var j = 0; j < f[0].length; j++) {
        if (i + py < 0 ||
            j + px < 0 ||
            i + py >= gameState.length ||
            j + px >= gameState[0].length) {
          if (f[i][j] != 0) {
            return true;
          } else {
            continue;
          }
        }

        if (gameState[i + py][j + px] != 0 && f[i][j] != 0) {
          return true;
        }
      }
    }
    return false;
  }

  destroyLinesAndShowNewFigure() {
    _destroyLines();
    _showNewFigure();
  }

  _destroyLines() {
    for (var i = rowCount - 1; i >= 0; i--) {
      bool rowIsFull = true;
      for (var j = 0; j < colCount; j++) {
        if (gameState[i][j] == 0) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        for (var ii = i; ii < rowCount; ii++) {
          for (var j = 0; j < colCount; j++) {
            if (ii == rowCount - 1) {
              gameState[ii][j] = 0;
            } else {
              gameState[ii][j] = gameState[ii + 1][j];
            }
          }
        }
      }
    }
  }

  _showNewFigure() {
    int index = Random().nextInt(TetrisFigure.figuresList.length);
    List<List<List<int>>> figures = List.generate(
        TetrisFigure.figuresList[index].length,
        (i) => List.generate(TetrisFigure.figuresList[index][i].length,
            (j) => List<int>.from(TetrisFigure.figuresList[index][i][j]),
            growable: false),
        growable: false);
    __showNewFigure(figures);
  }

  __showNewFigure(List<List<List<int>>> figures) {
    int x = (colCount - figures[0][0].length) ~/ 2;
    int y = rowCount - figures[0].length;
    int colorIndex = Random().nextInt(TetrisFigure.colors.length - 1) + 1;
    currentFigure = TetrisFigure(
        figures: figures, position: Point(x, y), colorIndex: colorIndex);
    gameStatePlusFigure = statePlusFigure();
  }

  List<List<int>> statePlusFigure() {
    List<List<int>> state = List.generate(
        rowCount, (i) => List<int>.from(gameState[i]),
        growable: false);

    if (currentFigure == null) return state;
    var f = currentFigure!.figures[currentFigure!.rotationIndex];
    var px = currentFigure!.position.x;
    var py = currentFigure!.position.y;

    for (var i = 0; i < f.length; i++) {
      for (var j = 0; j < f[0].length; j++) {
        if (i + py < 0 ||
            j + px < 0 ||
            i + py >= gameState.length ||
            j + px >= gameState[0].length) {
          continue;
        }
        if (gameState[i + py][j + px] == 0) {
          state[i + py][j + px] = f[i][j];
        }
      }
    }
    print(state);
    return state;
  }
}
