extends AnimationPlayer


var collisions_array = {}


func _ready():
	collisions_array["CollisionPolygon2D_Static"] = get_parent().get_node("CollisionPolygon2D_Static")
	collisions_array["CollisionPolygon2D_Moving_Right"] = get_parent().get_node("CollisionPolygon2D_Moving_Right")
	collisions_array["CollisionPolygon2D_Moving_Left"] = get_parent().get_node("CollisionPolygon2D_Moving_Left")
	collisions_array["CollisionPolygon2D_Climbing_Descending"] = get_parent().get_node("CollisionPolygon2D_Climbing_Descending")
	collisions_array["CollisionPolygon2D_Falling"] = get_parent().get_node("CollisionPolygon2D_Falling")



func play_idle():
	play("Idle")
	set_collision("CollisionPolygon2D_Static")


func play_moving_right():
	play("Moving_Right")
	set_collision("CollisionPolygon2D_Moving_Right")


func play_moving_left():
	play("Moving_Left")
	set_collision("CollisionPolygon2D_Moving_Left")


func play_shooting():
	play("Shooting")
	set_collision("CollisionPolygon2D_Static")


func play_climbing():
	play("Climbing")
	set_collision("CollisionPolygon2D_Climbing_Descending")


func play_descending():
	play("Descending")
	set_collision("CollisionPolygon2D_Climbing_Descending")


func play_falling():
	play("Falling")
	set_collision("CollisionPolygon2D_Falling")


func play_dead():
	play("Dead")


func play_won():
	play("Won")


func set_collision(key:String):
	for value in collisions_array.values():
		value.disabled= true
		value.visible= false
	var current_collision = collisions_array.get(key)
	if current_collision != null:
		current_collision.disabled= false
		current_collision.visible= true
