extends Area2D

var speed = -750

func _physics_process(delta):
	position += transform.y * speed * delta

#func _on_Bullet_body_entered(body):
#	if body.is_in_group("bubbles"):
#		body.emit_signal("bubble_destroyed")
#	if body.is_in_group("destructible_platforms"):
#		body.emit_signal("platform_destroyed")
#	queue_free()

func destroy_remote_bullet():
	queue_free()

#
#func _on_Bullet_body_entered(body):
#	if !body.is_in_group("bubbles") and !body.is_in_group("destructible_platforms"):
#		queue_free()
