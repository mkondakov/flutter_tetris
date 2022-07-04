import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'tetris_figure.dart';

enum TetrisGameState { initialized, started, finished, paused }

class TetrisModel {
  TetrisModel(
      {required this.rowCount,
      required this.colCount,
      required this.timerCallback})
      : gameState = List.generate(
            rowCount, (i) => List<int>.filled(colCount, 0),
            growable: false),
        gameStatePlusFigure = List.generate(
            rowCount, (i) => List<int>.filled(colCount, 0),
            growable: false),
        state = TetrisGameState.initialized,
        gameSpeed = 1,
        score = 0 {}

  final int rowCount;
  final int colCount;

  VoidCallback timerCallback;
  TetrisGameState state;
  int gameSpeed;
  List<List<int>> gameState;
  List<List<int>> gameStatePlusFigure;
  TetrisFigure? currentFigure;
  int score;

  Timer? fallTimer;
  Timer? addSpeedTimer;

  initialize() {
    gameState = List.generate(rowCount, (i) => List<int>.filled(colCount, 0),
        growable: false);
    gameStatePlusFigure = List.generate(
        rowCount, (i) => List<int>.filled(colCount, 0),
        growable: false);

    gameSpeed = 1;
    score = 0;
    fallTimer?.cancel();
    fallTimer = null;

    addSpeedTimer?.cancel();
    addSpeedTimer = null;

    state = TetrisGameState.initialized;
  }

  start() {
    initialize();
    destroyLinesAndShowNewFigure();

    _resetFallDawnTimer();
    addSpeedTimer = Timer(const Duration(seconds: 30), _handleAddSpeedTimer);
    state = TetrisGameState.started;
  }

  finish() {
    fallTimer?.cancel();
    fallTimer = null;

    addSpeedTimer?.cancel();
    addSpeedTimer = null;

    state = TetrisGameState.finished;
  }

  _handleFallTimer() {
    down();
  }

  _resetFallDawnTimer() {
    int fallSpeed = 1300 ~/ gameSpeed;
    fallTimer?.cancel();
    fallTimer = null;
    fallTimer = Timer(Duration(milliseconds: fallSpeed), _handleFallTimer);
  }

  _handleAddSpeedTimer() {
    gameSpeed += 1;
  }

  left() {
    if (state != TetrisGameState.started) return;
    if (currentFigure == null) return;
    var cf = currentFigure!;
    var nf = cf.clone();
    nf.position = Point(cf.position.x - 1, cf.position.y);

    if (!_isStateCollideWith(nf)) {
      currentFigure = nf;
      gameStatePlusFigure = statePlusFigure();
    }
    timerCallback();
  }

  right() {
    if (state != TetrisGameState.started) return;
    if (currentFigure == null) return;
    var cf = currentFigure!;
    var nf = cf.clone();
    nf.position = Point(cf.position.x + 1, cf.position.y);

    if (!_isStateCollideWith(nf)) {
      currentFigure = nf;
      gameStatePlusFigure = statePlusFigure();
    }
    timerCallback();
  }

  hardDrop() {
    if (state != TetrisGameState.started) return;
    _resetFallDawnTimer();

    int dropdownScores = 0;
    while (_downIfPossible()) {
      dropdownScores += 1;
    }
    score += dropdownScores;
    gameState = gameStatePlusFigure;
    destroyLinesAndShowNewFigure();
    if (_isStateCollideWith(currentFigure!)) {
      finish();
    }
    timerCallback();
  }

  down() {
    if (state != TetrisGameState.started) return;
    _resetFallDawnTimer();
    if (!_downIfPossible()) {
      gameState = gameStatePlusFigure;
      destroyLinesAndShowNewFigure();
      if (_isStateCollideWith(currentFigure!)) {
        finish();
      }
    }
    timerCallback();
  }

  bool _downIfPossible() {
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
    if (state != TetrisGameState.started) return;
    if (currentFigure == null) return;
    var cf = currentFigure!;

    for (var i = 0; i < 4; i++) {
      cf = _rotateByRotationIndexAndCreateNewFigure(cf);
      if (!_isStateCollideWith(cf)) {
        currentFigure = cf;
        gameStatePlusFigure = statePlusFigure();
        timerCallback();
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
    int destroyedLinesCount = 0;

    for (var i = rowCount - 1; i >= 0; i--) {
      bool rowIsFull = true;
      for (var j = 0; j < colCount; j++) {
        if (gameState[i][j] == 0) {
          rowIsFull = false;
          break;
        }
      }

      if (rowIsFull) {
        destroyedLinesCount += 1;
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

    int coef = 0;
    if (destroyedLinesCount == 1) {
      coef = 40;
    } else if (destroyedLinesCount == 2) {
      coef = 100;
    } else if (destroyedLinesCount == 3) {
      coef = 300;
    } else if (destroyedLinesCount == 4) {
      coef = 1200;
    }

    score += coef * gameSpeed;
  }

  _showNewFigure() {
    int index = Random().nextInt(TetrisFigure.figuresList.length);
    List<List<List<int>>> figures = List.generate(
        TetrisFigure.figuresList[index].length,
        (i) => List.generate(TetrisFigure.figuresList[index][i].length,
            (j) => List<int>.from(TetrisFigure.figuresList[index][i][j]),
            growable: false),
        growable: false);
    __showNewFigure(figures, index + 1);
  }

  __showNewFigure(List<List<List<int>>> figures, int colorIndex) {
    int x = (colCount - figures[0][0].length) ~/ 2;
    int y = rowCount - figures[0].length;
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
    return state;
  }
}
