import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_flare/flame_flare.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flare_flutter/flare_controls.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with TapDetector, DoubleTapDetector {
  final paint = Paint()..color = const Color(0xFFE5E5E5E5);
  final List<String> _animations = ['Wave', 'Dance'];

  int _currentAnimation = 0;
  final MinionController minionController = MinionController();

  late final MinionComponent minionComponent;

  bool loaded = false;

  Future<void> onLoad() async {
    await super.onLoad();

    add(BGComponent());
    add(minionComponent = MinionComponent(minionController));

    minionController.playStand();
  }

  @override
  void onTap() {
    minionController.playJump();
  }

  @override
  void onDoubleTap() {
    cycleAnimation();
  }

  void cycleAnimation() {
    _currentAnimation = (_currentAnimation + 1) % _animations.length;
    minionController.play(_animations[_currentAnimation]);
  }
}

class MinionController extends FlareControls {
  void playStand() {
    play('Stand');
  }

  void playDance() {
    play('Dance');
  }

  void playJump() {
    play('Jump');
  }

  void playWave() {
    play('Wave');
  }
}

class MinionComponent extends FlareActorComponent {
  MinionController minionController;

  MinionComponent(this.minionController)
      : super(
          FlareActorAnimation(
            'assets/Bob_Minion.flr',
            controller: minionController,
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
          ),
          size: Vector2.all(300),
        );

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(x, y, width, height);
    final paint = Paint()..color = const Color(0xFFfafbfc);
    c.drawRect(rect, paint);
    super.render(c);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    position = (gameSize - size) / 2;
  }
}

class BGComponent extends Component with HasGameRef {
  static final paint = BasicPalette.white.paint();

  @override
  void render(Canvas c) {
    super.render(c);
    c.drawRect(gameRef.size.toRect(), paint);
  }
}
