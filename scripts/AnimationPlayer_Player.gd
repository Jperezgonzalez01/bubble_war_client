extends AnimationPlayer


func _ready():
	pass


func _process(delta):
	pass


func play_idle():
	play("Idle")
	set_collision_idle()


func play_moving_right():
	play("Moving_Right")
	set_collision_moving_right()


func play_moving_left():
	play("Moving_Left")
	set_collision_moving_left()


func play_shooting():
	play("Shooting")
	set_collision_idle()


func set_collision_moving_right():
	get_parent().get_node("CollisionPolygon2D_Static").disabled= true
	get_parent().get_node("CollisionPolygon2D_Static").visible= false
	get_parent().get_node("CollisionPolygon2D_Moving_Right").disabled= false
	get_parent().get_node("CollisionPolygon2D_Moving_Right").visible= true
	get_parent().get_node("CollisionPolygon2D_Moving_Left").disabled= true
	get_parent().get_node("CollisionPolygon2D_Moving_Left").visible= false


func set_collision_moving_left():
	get_parent().get_node("CollisionPolygon2D_Static").disabled= true
	get_parent().get_node("CollisionPolygon2D_Static").visible= false
	get_parent().get_node("CollisionPolygon2D_Moving_Right").disabled= true
	get_parent().get_node("CollisionPolygon2D_Moving_Right").visible= false
	get_parent().get_node("CollisionPolygon2D_Moving_Left").disabled= false
	get_parent().get_node("CollisionPolygon2D_Moving_Left").visible= true


func set_collision_idle():
	get_parent().get_node("CollisionPolygon2D_Static").disabled= false
	get_parent().get_node("CollisionPolygon2D_Static").visible= true
	get_parent().get_node("CollisionPolygon2D_Moving_Right").disabled= true
	get_parent().get_node("CollisionPolygon2D_Moving_Right").visible= false
	get_parent().get_node("CollisionPolygon2D_Moving_Left").disabled= true
	get_parent().get_node("CollisionPolygon2D_Moving_Left").visible= false
