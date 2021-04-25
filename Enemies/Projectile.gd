extends Area2D

var speed = 200

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		body
	queue_free()


func _on_Projectile_area_entered(area):
	if area.is_in_group("player"):
		area.owner.take_hit(self)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Projectile_body_entered(body):
	queue_free()
