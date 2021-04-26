extends Node2D

var target
var projectile_scene := preload("res://Enemies/Projectile.tscn")

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
		Events.emit_signal("enemy_killed", global_position)
		queue_free()

func _on_AggroRange_area_entered(area):
	if area.is_in_group("player"):
		target = area

func _on_AggroRange_area_exited(area):
	if area == target:
		target = null

func is_alive() -> bool:
	return current_state != States.DEAD
