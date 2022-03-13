extends Node

enum DIRECTION_Y {
	EQUALS,
	UP,
	DOWN
}
enum DIRECTION_X {
	EQUALS,
	LEFT,
	RIGHT
}

static func get_direction_y(current_position:Vector2, previous_position:Vector2):
	#going up
	if current_position.y < previous_position.y:
		return DIRECTION_Y.UP
	#going down
	elif current_position.y > previous_position.y:
		return DIRECTION_Y.DOWN
	#no movement ocurred
	else:
		return DIRECTION_Y.EQUALS


static func get_direction_x(current_position:Vector2, previous_position:Vector2):
	#going left
	if current_position.x < previous_position.x:
		return DIRECTION_X.LEFT
	#going right
	elif current_position.y > previous_position.y:
		return DIRECTION_X.RIGHT
	#no movement ocurred
	else:
		return DIRECTION_X.EQUALS


static func direction_changed(current_direction:int, previous_direction:int):
	return previous_direction != current_direction


static func x_has_movement(current_position:Vector2, previous_position:Vector2):
	return current_position.x != previous_position.x


static func y_has_movement(current_position:Vector2, previous_position:Vector2):
	return current_position.y != previous_position.y


static func must_move_left():
	return InputManager.get_input_force_x() < 0


static func must_move_right():
	return InputManager.get_input_force_x() > 0
