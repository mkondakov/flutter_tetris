import 'package:flutter/services.dart';

enum TetrisKey { left, right, up, down, space, unknown }

class KeyboardHandling {
  static TetrisKey getKey(RawKeyEvent key) {
    // print("Event runtimeType is ${key.runtimeType}");
    if (key.runtimeType.toString() == 'RawKeyDownEvent') {
      if (key.data is RawKeyEventDataMacOs) {
        RawKeyEventDataMacOs data = key.data as RawKeyEventDataMacOs;
        return _handleMacKeyboard(data.keyCode);
      } else if (key.data is RawKeyEventDataIos) {
        RawKeyEventDataIos data = key.data as RawKeyEventDataIos;
        return _handleIosKeyboard(data.keyCode);
      } else if (key.data is RawKeyEventDataWeb) {
        RawKeyEventDataWeb data = key.data as RawKeyEventDataWeb;
        return _handleWebKeyboard(data.keyCode);
      }
    }
    return TetrisKey.unknown;
  }

  static TetrisKey _handleMacKeyboard(int keyCode) {
    print('keyCode == $keyCode');
    switch (keyCode) {
      case 123:
        return TetrisKey.left;
      case 124:
        return TetrisKey.right;
      case 126:
        return TetrisKey.up;
      case 125:
        return TetrisKey.down;
      case 49:
        return TetrisKey.space;
      default:
        return TetrisKey.unknown;
    }
  }

  static TetrisKey _handleIosKeyboard(int keyCode) {
    print('keyCode == $keyCode');
    switch (keyCode) {
      case 80:
        return TetrisKey.left;
      case 79:
        return TetrisKey.right;
      case 82:
        return TetrisKey.up;
      case 81:
        return TetrisKey.down;
      case 49:
        return TetrisKey.space;
      default:
        return TetrisKey.unknown;
    }
  }

  static TetrisKey _handleWebKeyboard(int keyCode) {
    print('keyCode == $keyCode');
    switch (keyCode) {
      case 37:
        return TetrisKey.left;
      case 39:
        return TetrisKey.right;
      case 38:
        return TetrisKey.up;
      case 40:
        return TetrisKey.down;
      case 32:
        return TetrisKey.space;
      default:
        return TetrisKey.unknown;
    }
  }
}
