extends RayCast2D

func _ready():
	for i in range(4):
		var rot = 90 * i
		rotation_degrees = rot
		force_raycast_update()
		if is_colliding():
			owner.rotation_degrees = rot
			owner.global_position = get_collision_point()
			return
