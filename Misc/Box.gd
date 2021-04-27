extends Node2D


var health_drop = preload("res://Misc/HealthDrop.tscn")
var health_drop_change = 0.04

func hit() -> void:
	$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		if randf() <= health_drop_change:
			var drop = health_drop.instance()
			drop.global_position = global_position
			owner.add_child(drop)
		Events.emit_signal("box_destroyed")
		queue_free()
