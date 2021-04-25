extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("restart_game", self, "restart_game")
	Events.connect("swap_color", self, "swap_color")
	
	
func restart_game() -> void:
	get_tree().reload_current_scene()

func swap_color(color_1: Color, color_2: Color, color_3: Color) -> void:
	var current_replace_0 = $ViewportContainer.material.get_shader_param("replace_0")
	var current_replace_1 = $ViewportContainer.material.get_shader_param("replace_1")
	var current_replace_2 = $ViewportContainer.material.get_shader_param("replace_2")
	
	var animation = $AnimationPlayer.get_animation("swap_color")
	animation.track_set_key_value(0, 0, current_replace_0)
	animation.track_set_key_value(0, 2, current_replace_1)
	animation.track_set_key_value(0, 4, current_replace_2)
	
	animation.track_set_key_value(0, 1, color_1)
	animation.track_set_key_value(0, 3, color_2)
	animation.track_set_key_value(0, 5, color_3)
	$AnimationPlayer.play("swap_color")
	
