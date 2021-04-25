extends Node2D

export(Array, Image) var templates
export(Vector2) var tile_size := Vector2(12, 12)
 
var slime := preload("res://Enemies/Slime.tscn")
var player_scene := preload("res://Player/Player.tscn")

var level_size = [2]
onready var tile_map = $TileMap

func spawn_player() -> void:
	$PlayerSpawn
	var player := player_scene.instance()
	add_child(player)
	player.global_position = $PlayerSpawn.global_position

func _ready():
	var y_offset = 7
	load_level_from_image(templates[0], y_offset)
	y_offset += templates[0].get_height()
	load_level_from_image(templates[1], y_offset)
	spawn_player()

func load_level_from_image(image: Image, y_offset: int):
	image.lock()
	var width = image.get_width()
	var height = image.get_height()
	
	for j in range(height):
		tile_map.set_cell(-1, j + y_offset, 0)
		tile_map.set_cell(0, j + y_offset, 0)
		tile_map.set_cell(14, j + y_offset, 0)
		tile_map.set_cell(15, j + y_offset, 0)
		for i in range(width):
			print(i, ' - ',j)
			var color = image.get_pixel(i, j)
			match color:
				Color.black:
					tile_map.set_cell(i + 1, j + y_offset, 0)
				Color.red:
					spawn_enemy_at_cell(slime, i + 1, j + y_offset)
	image.unlock()
	tile_map.update_dirty_quadrants()
	tile_map.update_bitmask_region()

func spawn_enemy_at_cell(enemy_scene: PackedScene, x: int, y: int) -> void:
	var enemy := enemy_scene.instance()
	enemy.global_position = Vector2(x * tile_size.x, y * tile_size.y)
	tile_map.add_child(enemy)
