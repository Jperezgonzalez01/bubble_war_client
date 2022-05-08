extends PlayerState


func _ready() -> void:
	state_name = "MovingLeftState"


func enter(_msg := {}) -> void:
	animation_player.play_moving_left()


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
