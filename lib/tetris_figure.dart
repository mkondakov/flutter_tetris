import 'package:flutter/material.dart';
import 'dart:math';

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
        [1, 1], //    * *
        [1, 1], //    * *
      ],
    ],
    [
      [
        [0, 1, 0, 0], //   *
        [0, 1, 0, 0], //   *
        [0, 1, 0, 0], //   *
        [0, 1, 0, 0], //   *
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
        [0, 0, 0], //  * *
        [0, 1, 1], //    * *
        [1, 1, 0], //
      ],
      [
        [0, 1, 0],
        [0, 1, 1],
        [0, 0, 1],
      ],
    ],
    [
      [
        [0, 0, 0], //    * *
        [1, 1, 0], //  * *
        [0, 1, 1], //
      ],
      [
        [0, 0, 1],
        [0, 1, 1],
        [0, 1, 0],
      ],
    ],
    [
      [
        [0, 1, 0], //   * *
        [0, 1, 0], //     *
        [1, 1, 0], //     *
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
    ],
    [
      [
        [1, 0, 0], //     * *
        [1, 0, 0], //     *
        [1, 1, 0], //     *
      ],
      [
        [0, 0, 0],
        [0, 0, 1],
        [1, 1, 1],
      ],
      [
        [1, 1, 0],
        [0, 1, 0],
        [0, 1, 0],
      ],
      [
        [0, 0, 0],
        [1, 1, 1],
        [1, 0, 0],
      ],
    ],
    [
      [
        [0, 0, 0], //       *
        [1, 1, 1], //     * * *
        [0, 1, 0], //
      ],
      [
        [1, 0, 0],
        [1, 1, 0],
        [1, 0, 0],
      ],
      [
        [0, 0, 0],
        [0, 1, 0],
        [1, 1, 1],
      ],
      [
        [0, 1, 0],
        [1, 1, 0],
        [0, 1, 0],
      ],
    ],
  ];

  static final List<Color> colors = <Color>[
    Colors.black,
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.cyan,
    Colors.indigo,
    Colors.purple,
    Colors.yellow,
    // Colors.cyan,
    // Colors.teal,
    // Colors.green,
    // Colors.lightGreen,
    // Colors.lime,
    // Colors.yellow,
    // Colors.amber,
    // Colors.orange,
    // Colors.deepOrange,
    // Colors.brown,
    // Colors.blueGrey,
  ];
}
