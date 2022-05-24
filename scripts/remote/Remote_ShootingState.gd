extends PlayerState

var emit_shoot = false


func _ready() -> void:
	state_name = "ShootingState"


func enter(_msg := {}) -> void:
	pass


func set_emit_shoot_true():
	emit_shoot = true


func update(delta: float) -> void:
	if kinematic_player.is_player_dead():
		state_machine.transition_to("DeadState")
	elif kinematic_player.is_player_winning():
		state_machine.transition_to("WonState")
	elif emit_shoot:
		animation_player.play_shooting()
		emit_shoot = false
