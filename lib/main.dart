import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_tetris/tetris_model.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return const MaterialApp(title: 'Tetris', home: GamePage());
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(child: TetrisStateWidget())));
  }
}

class TetrisStateWidget extends StatefulWidget {
  const TetrisStateWidget({Key? key}) : super(key: key);

  @override
  State<TetrisStateWidget> createState() => _TetrisStateWidget();
}

class _TetrisStateWidget extends State<TetrisStateWidget> {
  late TetrisModel _model;

  @override
  void initState() {
    super.initState();
    _model = TetrisModel(rowCount: 20, colCount: 10);
    _model.destroyLinesAndShowNewFigure();
  }

  handleKey(RawKeyEvent key) {
    print("Event runtimeType is ${key.runtimeType}");
    if (key.runtimeType.toString() == 'RawKeyDownEvent') {
      RawKeyEventDataMacOs data = key.data as RawKeyEventDataMacOs;
      print(data.keyCode == 123);
      if (data.keyCode == 123) {
        setState(() {
          _model.left();
        });
      } else if (data.keyCode == 124) {
        setState(() {
          _model.right();
        });
      } else if (data.keyCode == 126) {
        setState(() {
          _model.rotate();
        });
      } else if (data.keyCode == 125) {
        setState(() {
          if (!_model.downIfPossible()) {
            _model.gameState = _model.gameStatePlusFigure;
            _model.destroyLinesAndShowNewFigure();
          }
        });
      }
      //String _keyCode;
      //_keyCode = data.keyCode.toString(); //keycode of key event (66 is return)

      //print("why does this run twice $_keyCode");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: handleKey,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10),
          itemCount: 200,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: TetrisFigure.colors[
                  _model.gameStatePlusFigure[(19 - (index ~/ 10)).toInt()]
                          [index % 10] %
                      TetrisFigure.colors.length],
              child: null,
            );
          },
        ));
  }
}
