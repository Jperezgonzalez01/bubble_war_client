extends PlayerState


func _ready() -> void:
	pass


func enter(_msg := {}) -> void:
	animation_player.play_moving_right()


func update(delta: float) -> void:
	var force_x = InputManager.get_input_force_x()
	if force_x > 0:
		var velocity_x = force_x * WALK_SPEED
		kinematic_player.move_and_slide(Vector2(velocity_x, 0), Vector2(0, -1))
	elif force_x == 0:
		state_machine.transition_to("IdleState")
