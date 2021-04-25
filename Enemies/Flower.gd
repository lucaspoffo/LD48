extends Node2D

var target
var projectile_scene := preload("res://Enemies/Projectile.tscn")

func _ready():
	find_wall()

func find_wall() -> void:
	for i in range(4):
		var rot = 90 * i
		$WallCast.rotation_degrees = rot
		$WallCast.force_raycast_update()
		if $WallCast.is_colliding():
			rotation_degrees = rot
			global_position = $WallCast.get_collision_point()
			return

enum States {
	IDLE,
	DEAD,
	ATTACK,
}

var current_state = States.IDLE

func _physics_process(delta):
	match current_state:
		States.IDLE:
			if target and $AttackTimer.is_stopped():
				current_state = States.ATTACK
				$AnimatedSprite.play("attack")
		States.ATTACK:
			if !target:
				current_state = States.IDLE
				$AnimatedSprite.play("idle")
		States.DEAD:
			pass

func _exit_tree():
	pass

func hit() -> void:
	print("Hitt flower")
	$Area2D/CollisionShape2D.queue_free()
	current_state = States.DEAD
	$AnimatedSprite.play("death")

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "attack":
		$AnimatedSprite.play("idle")
		current_state = States.IDLE
		if target:
			var projectile = projectile_scene.instance()
			owner.add_child(projectile)
			var direction = $ProjectileSpawn.global_position.direction_to(target.global_position)
			projectile.rotation = direction.angle()
			projectile.global_position = $ProjectileSpawn.global_position
			$AttackTimer.start()
		
	if $AnimatedSprite.animation == "death":
		queue_free()

func _on_AggroRange_area_entered(area):
	if area.is_in_group("player"):
		target = area

func _on_AggroRange_area_exited(area):
	if area == target:
		target = null
