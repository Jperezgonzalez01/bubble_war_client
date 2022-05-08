extends PlayerState

func _ready() -> void:
	state_name = "DeadState"


func enter(_msg := {}) -> void:
	animation_player.play_dead()


func update(delta: float) -> void:
	if !animation_player.is_playing():
		get_tree().paused = false
