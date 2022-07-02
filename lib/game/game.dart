import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:layout/game/level/level.dart';

class SimplePlatformer extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents{
  Level? _currentLevel;
  late Image spriteSheet;


  @override
  Future<void>? onLoad() async {

    Flame.device.fullScreen();
    Flame.device.setLandscape();


    spriteSheet = await images.load('Spritesheet.png');

    camera.viewport = FixedResolutionViewport(Vector2(640, 350));

    loadLevel('level1.tmx');

    return super.onLoad();
  }

  void loadLevel(String levelName) {
    _currentLevel?.removeFromParent();
    _currentLevel = Level(levelName);
    add(_currentLevel!);


  }

}
