extends PlayerState

func _ready() -> void:
	state_name = "DescendingState"


func enter(_msg := {}) -> void:
	#Play descending animation --> animation_player.play_descending()
	animation_player.play_descending()


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
