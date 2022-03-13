extends PlayerState

func _ready() -> void:
	pass


func enter(_msg := {}) -> void:
	animation_player.play_idle()


func update(delta: float) -> void:
	if InputManager.get_input_force_x() > 0:
		state_machine.transition_to("MovingRightState")
	elif InputManager.get_input_force_x() < 0:
		state_machine.transition_to("MovingLeftState")
	elif InputManager.get_input_force_y() < 0:
		state_machine.transition_to("ClimbingState")
	elif InputManager.get_input_force_y() > 0:
		state_machine.transition_to("DescendingState")
	elif InputManager.player_pulled_trigger():
		state_machine.transition_to("ShootingState")
