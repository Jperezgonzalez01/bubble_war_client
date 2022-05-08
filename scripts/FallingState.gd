extends PlayerState


func _ready() -> void:
	state_name = "FallingState"


func enter(_msg := {}) -> void:
	#Play falling animation --> animation_player.play_falling()
	animation_player.play_falling()


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
	elif kinematic_player.is_in_ladder() or kinematic_player.is_on_floor():
		state_machine.transition_to("IdleState")
