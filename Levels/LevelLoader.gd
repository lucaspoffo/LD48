extends Node2D

var player_scene := preload("res://Player/Player.tscn")

export(Array, PackedScene) var depth_1_templates
export(Array, PackedScene) var depth_2_templates
export(Array, PackedScene) var depth_3_templates
export(Array, PackedScene) var depth_4_templates
export(Array, PackedScene) var depth_5_templates

onready var next_level_position = $StartLevelPosition.global_position

func spawn_player() -> void:
	var player := player_scene.instance()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position

func _ready():
	spawn_depth(depth_1_templates)
	spawn_depth(depth_1_templates)
	spawn_depth(depth_1_templates)
	spawn_depth(depth_1_templates)
	spawn_depth(depth_1_templates)
	# spawn_player()

func spawn_depth(templates: Array) -> void:
	for i in range(GameManager.levels_per_depth):
		var template = templates[randi() % templates.size()]
		spawn_level_template(template)

func spawn_level_template(level_template: PackedScene) -> void:
	var level = level_template.instance()
	level.global_position = next_level_position
	$Levels.add_child(level)
	next_level_position = level.next_level_position()
