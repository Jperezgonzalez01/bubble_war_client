extends Node


enum JOYSTICK_DIRECTION {
	EQUALS,
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var previous_joystick_direction : int = JOYSTICK_DIRECTION.EQUALS


func get_input_force_x() -> int:
	var velocity_x = 0
	if Input.is_action_pressed("move_right"):
		velocity_x += 1
	if Input.is_action_pressed("move_left"):
		velocity_x += -1
	return velocity_x


func get_just_pressed_input_force_x() -> int:
	var velocity_x = 0
	if Input.is_action_just_pressed("move_right"):
		velocity_x += 1
	if Input.is_action_just_pressed("move_left"):
		velocity_x += -1
	return velocity_x


func get_input_force_y() -> int:
	var velocity_y = 0
	if Input.is_action_pressed("move_down"):
		velocity_y += 1
	if Input.is_action_pressed("move_up"):
		velocity_y += -1
	return velocity_y


func get_just_pressed_input_force_y() -> int:
	var velocity_y = 0
	if Input.is_action_just_pressed("move_down"):
		velocity_y += 1
	if Input.is_action_just_pressed("move_up"):
		velocity_y += -1
	return velocity_y


func is_player_moving() -> bool:
	return get_input_force_x() != 0 or get_input_force_y() != 0


func player_pulled_trigger() -> bool:
	return Input.is_action_just_pressed("shoot")


func update_android_joystick_movement(move_vector):
	var current_joystick_direction = get_prevailing_direction(move_vector)
	if current_joystick_direction != previous_joystick_direction:
		release_android_joystick_movement()
		previous_joystick_direction = current_joystick_direction
	if current_joystick_direction == JOYSTICK_DIRECTION.RIGHT:
		Input.action_press("move_right", move_vector.x)
	elif current_joystick_direction == JOYSTICK_DIRECTION.LEFT:
		Input.action_press("move_left", move_vector.x)
	elif current_joystick_direction == JOYSTICK_DIRECTION.DOWN:
		Input.action_press("move_down", move_vector.y)
	elif current_joystick_direction == JOYSTICK_DIRECTION.UP:
		Input.action_press("move_up", move_vector.y)


func get_prevailing_direction(move_vector):
	if abs(move_vector.x) > abs(move_vector.y):
		if move_vector.x > 0:
			return JOYSTICK_DIRECTION.RIGHT
		elif move_vector.x < 0:
			return JOYSTICK_DIRECTION.LEFT
	elif abs(move_vector.x) < abs(move_vector.y):
		if move_vector.y > 0:
			return JOYSTICK_DIRECTION.DOWN
		elif move_vector.y < 0:
			return JOYSTICK_DIRECTION.UP
	else:
		return JOYSTICK_DIRECTION.EQUALS


func release_android_joystick_movement():
	Input.action_release("move_right")
	Input.action_release("move_left")
	Input.action_release("move_down")
	Input.action_release("move_up")


func press_android_shoot_button():
	Input.action_press("shoot")


func release_android_shoot_button():
	Input.action_release("shoot")
