import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'tetris_model.dart';
import 'tetris_figure.dart';
import 'keyboard_handling.dart';

void main() {
  runApp(const TetrisApp());
}

class LabelTextStyle {
  static TextStyle? bodyText1(BuildContext context) {
    return Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 42,
          color: Colors.white,
          letterSpacing: 2.0,
        );
  }
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
  late TetrisModel _model;

  @override
  void initState() {
    super.initState();
    _model =
        TetrisModel(rowCount: 20, colCount: 10, timerCallback: _handleTimer);
    _model.start();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 30, 30, 30),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
                child: Row(children: <Widget>[
              Expanded(
                  child: Center(
                      child: AspectRatio(
                          aspectRatio: 0.5,
                          child: TetrisStateWidget(model: _model)))),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Level: ${_model.gameSpeed}",
                        style: LabelTextStyle.bodyText1(context)),
                    Text("Score: ${_model.score}",
                        style: LabelTextStyle.bodyText1(context)),
                  ],
                ),
              ),
            ]))));
  }

  _handleTimer() {
    setState(() {});
  }
}

class TetrisStateWidget extends StatelessWidget {
  TetrisStateWidget({Key? key, required this.model}) : super(key: key);

  TetrisModel model;

  _handleKey(RawKeyEvent key) {
    var keyPressed = KeyboardHandling.getKey(key);
    switch (keyPressed) {
      case TetrisKey.left:
        {
          model.left();
          break;
        }
      case TetrisKey.right:
        {
          model.right();
          break;
        }
      case TetrisKey.up:
        {
          model.rotate();
          break;
        }
      case TetrisKey.down:
        {
          model.down();
          break;
        }
      case TetrisKey.space:
        {
          model.hardDrop();
          break;
        }
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: _handleKey,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10),
          itemCount: 200,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: const EdgeInsets.only(
                  left: 1.0, right: 1.0, top: 1.0, bottom: 1.0),
              color: TetrisFigure.colors[
                  model.gameStatePlusFigure[(19 - (index ~/ 10)).toInt()]
                          [index % 10] %
                      TetrisFigure.colors.length],
              child: null,
            );
          },
        ));
  }
}
