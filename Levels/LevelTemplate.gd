extends Node2D

var player_already_entered = false

func next_level_position() -> Vector2:
	return $NextLevelPosition.global_position

func _on_Area2D_area_entered(area):
	if !player_already_entered:
		Events.emit_signal("entered_new_level")
		player_already_entered = true
