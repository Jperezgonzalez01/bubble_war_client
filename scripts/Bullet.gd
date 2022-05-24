extends Area2D

signal bullet_destoyed()

var speed = -750
var direction = Vector2(0, 1)

func _physics_process(delta):
	position += delta * direction * speed

func _on_Bullet_body_entered(body):
	emit_signal("bullet_destoyed", self)
	if body.is_in_group("bubbles"):
		body.emit_signal("bubble_destroyed", body)
	if body.is_in_group("destructible_platforms"):
		body.emit_signal("platform_destroyed", body)
	queue_free()
