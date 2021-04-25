extends KinematicBody2D


export var movespeed := 25.0
var direction := 1

enum States {
	MOVE,
	DEAD,
	STOP,
}

var current_state = States.MOVE

func _physics_process(delta):
	match current_state:
		States.MOVE:
		# Flip direction
			if !$RayCastFloor.is_colliding() or $RayCastFront.is_colliding():
				scale.x *= -1
				direction *= -1
				current_state = States.STOP
			move_and_slide(Vector2(direction * movespeed, 90.8), Vector2.UP)
			$StopTimer.start()
		States.STOP:
			pass
		States.DEAD:
			pass

func _exit_tree():
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()

func hit() -> void:
	$Area2D/CollisionShape2D.queue_free()
	current_state = States.DEAD
	$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()

func _on_StopTimer_timeout():
	if current_state != States.DEAD:
		current_state = States.MOVE

func is_alive() -> bool:
	return current_state != States.DEAD
