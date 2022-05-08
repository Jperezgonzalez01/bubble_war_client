extends PlayerState

func _ready() -> void:
	state_name = "ClimbingState"


func enter(_msg := {}) -> void:
	#Play climbing animation --> animation_player.play_climbing()
	animation_player.play_climbing()


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
