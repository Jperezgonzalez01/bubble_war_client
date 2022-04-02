extends PlayerState

func _ready() -> void:
	pass


func enter(_msg := {}) -> void:
	#Play climbing animation --> animation_player.play_climbing()
	animation_player.play_idle()


func update(delta: float) -> void:
	if kinematic_player.is_in_ladder():
		var force_y = InputManager.get_input_force_y()
		if force_y < 0:
			var velocity_y = force_y * CLIMB_SPEED
			kinematic_player.move_and_slide(Vector2(0, velocity_y), Vector2.UP)
		if force_y == 0:
			state_machine.transition_to("IdleState")
	else:
		state_machine.transition_to("IdleState")
