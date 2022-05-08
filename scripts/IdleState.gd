extends PlayerState

func _ready() -> void:
	state_name = "IdleState"


func enter(_msg := {}) -> void:
	animation_player.play_idle()


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
	elif InputManager.get_input_force_x() > 0:
		state_machine.transition_to("MovingRightState")
	elif InputManager.get_input_force_x() < 0:
		state_machine.transition_to("MovingLeftState")
	elif InputManager.get_input_force_y() < 0 and kinematic_player.is_in_ladder():
		state_machine.transition_to("ClimbingState")
	elif InputManager.get_input_force_y() > 0 and kinematic_player.is_in_ladder():
		state_machine.transition_to("DescendingState")
	elif InputManager.player_pulled_trigger():
		state_machine.transition_to("ShootingState")
