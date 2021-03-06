import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:layout/game/actors/player.dart';
import 'package:layout/game/game.dart';

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SimplePlatformer> {

  static final Vector2 _up = Vector2(0, -1);
  Enemy(
    Image image, {
    Vector2? srcPosition,
    Vector2? srcSize,
    Vector2? targerPosition,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super.fromImage(image,
            srcPosition: Vector2(1 * 32, 0),
            srcSize: Vector2.all(32),
            position: position,
            size: size,
            scale: scale,
            angle: angle,
            anchor: anchor,
            priority: priority) {
    if (targerPosition != null && position != null) {
      /*add(MoveToEffect(
          targerPosition,
          EffectController(
            alternate: true,
            infinite: true,
            speed: 100,
          )));*/
      final effect = SequenceEffect(
        [
          MoveToEffect(targerPosition, EffectController(speed: 100),
              onComplete: () {
            flipHorizontallyAroundCenter();
          }),
          MoveToEffect(position + Vector2(32, 0), EffectController(speed: 100),
              onComplete: () {
            flipHorizontallyAroundCenter();
          })
        ],
        infinite: true,
      );

      add(effect);
    }
  }

  @override
  Future<void>? onLoad() {
    add(CircleHitbox()..collisionType = CollisionType.passive);
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) {
      final playerDir = (other.absoluteCenter - absoluteCenter).normalized();

      if(playerDir.dot(_up) > 0.85) {
          add(
            OpacityEffect.fadeOut(
              LinearEffectController(0.2),
              onComplete: () => removeFromParent(),
            ),
          );
          gameRef.playerData.health.value += 1;
          other.jump();
      } else {
        other.hit();
        if (gameRef.playerData.health.value > 0) {
          gameRef.playerData.health.value -= 1;
        }
      }


    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
