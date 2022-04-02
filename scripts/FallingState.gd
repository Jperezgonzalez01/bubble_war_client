extends PlayerState


func _ready() -> void:
	pass


func enter(_msg := {}) -> void:
	#Play falling animation --> animation_player.play_falling()
	animation_player.play_idle()


func update(delta: float) -> void:
	if kinematic_player.is_in_ladder() or kinematic_player.is_on_floor():
		state_machine.transition_to("IdleState")
