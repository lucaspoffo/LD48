extends Node2D

export(Array, Color) var depth_color

var health_drop = preload("res://Misc/HealthDrop.tscn")

onready var level_loader = $ViewportContainer/Viewport/LevelLoader 

var enemy_health_drop_change = 0.07

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("restart_game", self, "restart_game")
	Events.connect("depth_changed", self, "on_depth_change")
	Events.connect("enemy_killed", self, "on_enemy_killed")
	
func restart_game() -> void:
	get_tree().reload_current_scene()

func on_depth_change(depth):
	var animation = $AnimationPlayer.get_animation("swap_color")
	animation.track_set_key_value(0, 0, $ViewportContainer.modulate)
	animation.track_set_key_value(0, 1, depth_color[depth - 1])
	$AnimationPlayer.play("swap_color")

func on_enemy_killed(enemy_position):
	if randf() <= enemy_health_drop_change:
		var drop = health_drop.instance()
		drop.global_position = enemy_position
		level_loader.add_child(drop)
