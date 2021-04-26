extends KinematicBody2D

signal state_changed(name)
signal death

enum States {
	IDLE,
	MOVE,
	DASH,
	DEAD,
	AIR,
}

export var max_speed := Vector2(120.0, 340.0)
export var jump_impulse := 300.0
export var move_speed := 170.0
export var air_speed := 170.0
export var gravity := 680.0
export var dash_velocity := 500.0
export var dash_stop_velocity := 175.0
export var dash_hit_velocity := 275.0
export var enemy_hit_impulse := 350.0

export var move_acceleration := Vector2(10000, 3000.0)
export var air_acceleration := Vector2(1500, 3000.0)

var max_health := 3
var current_health := 3

var current_state = States.AIR
var horizontal_direction : = 0.0
var current_air_impulse := Vector2.ZERO

var velocity : = Vector2.ZERO

func _ready():
	current_health = max_health
	Events.emit_signal("player_health_changed", current_health, max_health)

func get_horizontal_direction() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func _physics_process(delta: float) -> void:
	horizontal_direction = get_horizontal_direction()
	match current_state:
		States.IDLE:
			if horizontal_direction:
				change_state(States.MOVE)
		States.MOVE:
			if !is_on_floor():
				change_state(States.AIR)
				return
			if !horizontal_direction:
				change_state(States.IDLE)
				return

			$AnimatedSprite.flip_h = horizontal_direction < 0.0
			velocity.x += horizontal_direction * move_acceleration.x * delta
			velocity.x = clamp(velocity.x, -move_speed, move_speed)
			var snap_vector = Vector2.DOWN * 6.0
			move_and_slide_with_snap(velocity, snap_vector, Vector2.UP)
			
		States.AIR:
			velocity.x += horizontal_direction * air_acceleration.x * delta
			if !horizontal_direction:
				velocity.x *= .93
			velocity.x = clamp(velocity.x, -air_speed, air_speed)
			velocity.y += gravity * delta
			velocity.y = min(max_speed.y, velocity.y)
			move_and_slide(velocity, Vector2.UP)
			if is_on_ceiling():
				velocity.y = 0.0
			if is_on_floor():
				change_state(States.MOVE)
		States.DASH:
			var collision = move_and_collide(velocity * delta)
			if collision:
				if collision.collider.is_in_group("hittable"):
					dash_collision(collision.collider)
				else:
					change_state(States.MOVE)
		States.DEAD:
			velocity.y += gravity * delta
			velocity.x *= .9
			move_and_slide(velocity, Vector2.UP)

func _unhandled_input(event) -> void:
	if current_state == States.DEAD:
		return
	
	if is_on_floor() and event.is_action_pressed("action") and (current_state == States.IDLE or current_state == States.MOVE):
		current_air_impulse = Vector2(0, -jump_impulse)
		change_state(States.AIR)
		return
	if event.is_action_pressed("action") and current_state == States.AIR and $DashCooldown.is_stopped():
		change_state(States.DASH)
		return

func change_state(new_state):
	exit_state(current_state)
	enter_state(new_state)

func enter_state(state):
	current_state = state
	emit_signal("state_changed", States.keys()[state])
	match state:
		States.IDLE:
			velocity.y = 0.0
			$DashCooldown.stop()
			$AnimatedSprite.play("idle")
		States.MOVE:
			velocity.y = 0.0
			$DashCooldown.stop()
			$AnimatedSprite.play("walk")
		States.DASH:
			velocity.y = dash_velocity
			velocity.x = 0.0
			$DashDuration.start()
			$DashCooldown.start()
			$AnimatedSprite.play("dash")
		States.AIR:
			if current_air_impulse != Vector2.ZERO:
				velocity = current_air_impulse
				current_air_impulse = Vector2.ZERO
			$AnimatedSprite.play("air")
		States.DEAD:
			pass

func exit_state(state):
	match state:
		States.IDLE:
			pass
		States.MOVE:
			pass
		States.DASH:
			$DashDuration.stop()
			velocity.y = -dash_stop_velocity
		States.AIR:
			pass
		States.DEAD:
			pass


func _on_DashDuration_timeout():
	change_state(States.AIR)

func _on_Area2D_area_entered(area: Area2D):
	match current_state:
		States.DASH:
			if area.is_in_group("hittable"):
				dash_collision(area)
			elif area.is_in_group("spike") and $InvulnerableTimer.time_left == 0:
				take_hit(area)
		States.AIR, States.MOVE, States.IDLE:
			if area.is_in_group("enemy") and $InvulnerableTimer.time_left == 0 and area.owner.is_alive():
				take_hit(area)

func dash_collision(target) -> void:
	for overlap in $DashArea.get_overlapping_bodies():
		if overlap != target and overlap.is_in_group("hittable") and overlap.owner.has_method("hit"):
			overlap.owner.hit()
	for overlap in $DashArea.get_overlapping_areas():
		if overlap != target and overlap.is_in_group("hittable") and overlap.owner.has_method("hit"):
			overlap.owner.hit()
	current_air_impulse = Vector2(0, -dash_hit_velocity)
	$DashCooldown.stop()
	if target.owner.has_method("hit"):
		target.owner.hit()
	change_state(States.AIR)

func take_hit(area: Area2D):
	if !$InvulnerableTimer.is_stopped():
		return
	$InvulnerableTimer.start()
	$Blinking.play("blinking")
	current_air_impulse = area.global_position.direction_to(global_position) * enemy_hit_impulse
	change_state(States.AIR)
	take_damage(1)

func _on_InvulnerableTimer_timeout():
	$Blinking.stop(true)
	$AnimatedSprite.modulate.a = 1
	for area in $Area2D.get_overlapping_areas():
		match current_state:
			States.AIR, States.MOVE, States.IDLE:
				if area.is_in_group("enemy"):
					take_hit(area)
					return
					
func take_damage(damage: int) -> void:
	current_health -= damage
	Events.emit_signal("player_health_changed", current_health, max_health)
	if current_health <= 0:
		die()

func die() -> void:
	change_state(States.DEAD)
	emit_signal("death")
	$DeathDelay.start()

func _on_DeathDelay_timeout():
	Events.emit_signal("restart_game")
