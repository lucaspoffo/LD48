extends Node2D

export(Array, Color) var depth_color

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("restart_game", self, "restart_game")
	Events.connect("depth_changed", self, "on_depth_change")
	
func restart_game() -> void:
	get_tree().reload_current_scene()

func on_depth_change(depth):
	var animation = $AnimationPlayer.get_animation("swap_color")
	animation.track_set_key_value(0, 0, $ViewportContainer.modulate)
	animation.track_set_key_value(0, 1, depth_color[depth - 1])
	$AnimationPlayer.play("swap_color")
