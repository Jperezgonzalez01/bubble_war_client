extends PlayerState

signal fire_weapon()


func _ready() -> void:
	pass


func enter(_msg := {}) -> void:
	animation_player.play_shooting()
	emit_signal("fire_weapon")


func update(delta: float) -> void:
	if InputManager.get_input_force_x() > 0:
		state_machine.transition_to("MovingRightState")
	elif InputManager.get_input_force_x() < 0:
		state_machine.transition_to("MovingLeftState")
	elif InputManager.player_pulled_trigger():
		animation_player.play_shooting()
		emit_signal("fire_weapon")
