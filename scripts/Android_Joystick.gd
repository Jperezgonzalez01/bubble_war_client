extends Node2D

signal virtual_joystick_moved()


func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if $TouchScreenButton.is_pressed():
			var move_vector = calculate_move_vector(event.position)
			InputManager.update_android_joystick_movement(move_vector)


func calculate_move_vector(event_position):
	var texture_center = $TouchScreenButton.get_global_position() + Vector2(80, 80)
	$Sprite_Finger_Pointer.set_global_position(event_position)
	return (event_position - texture_center).normalized()


func _on_TouchScreenButton_released():
	InputManager.release_android_joystick_movement()
	$Sprite_Finger_Pointer.set_global_position($TouchScreenButton.get_global_position() + Vector2(80, 80))
