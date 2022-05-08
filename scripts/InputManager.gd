extends Node

signal fire_weapon

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


func check_player_shooting() -> void:
	if player_can_shoot():
		emit_signal("fire_weapon")


func player_can_shoot() -> bool:
	return Input.is_action_just_pressed("shoot") and !is_player_moving()


func is_player_shooting() -> bool:
	return Input.is_action_pressed("shoot") or Input.is_action_just_pressed("shoot")

func player_pulled_trigger() -> bool:
	return Input.is_action_just_pressed("shoot")
