extends Node2D

var mineral_drop_scene = preload("res://Misc/MineralDrop.tscn")

func hit() -> void:
	$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		var num_drop = range(2,5)[randi() % 3]
		for i in range(num_drop):
			var drop = mineral_drop_scene.instance()
			owner.add_child(drop)
			drop.global_position = global_position
		Events.emit_signal("mineral_destroyed")
		queue_free()
