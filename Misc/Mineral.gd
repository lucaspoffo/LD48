extends Node2D

func hit() -> void:
	$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		Events.emit_signal("mineral_destroyed")
		queue_free()
