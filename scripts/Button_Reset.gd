extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


func _on_Button_Restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
