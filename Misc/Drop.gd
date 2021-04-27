extends Node2D

var velocity: Vector2
var max_speed = 200
var acceleration = 1000
var player

func _ready():
	var random_direction = Vector2(randf(), randf()).normalized()
	var nodes = get_tree().get_nodes_in_group("player")
	velocity = random_direction * max_speed
	if nodes.size() > 0:
		player = nodes[0]

func _process(delta):
	if !player:
		owner.queue_free()
		return
	
	var player_direction = global_position.direction_to(player.global_position)
	
	velocity += acceleration * player_direction * delta
	velocity = velocity.clamped(max_speed)
	owner.global_position += velocity * delta
	
func _on_Area2D_area_entered(area):
	owner.player_collect()
	owner.queue_free()
