extends PlayerState


func _ready() -> void:
	state_name = "MovingRightState"


func enter(_msg := {}) -> void:
	animation_player.play_moving_right()


func update(delta: float) -> void:
	var force_x = InputManager.get_input_force_x()
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
	elif InputManager.player_pulled_trigger():
		state_machine.transition_to("ShootingState")
	elif force_x > 0:
		var velocity_x = force_x * WALK_SPEED
		kinematic_player.move_and_slide(Vector2(velocity_x, 0), Vector2.UP)

		if !kinematic_player.is_in_ladder() and !kinematic_player.is_on_floor():
			state_machine.transition_to("FallingState")
	elif force_x < 0:
		state_machine.transition_to("MovingLeftState")
	elif force_x == 0:
		state_machine.transition_to("IdleState")
