extends Button


var state = null

# Called when the node enters the scene tree for the first time.
func _ready():
	state = "Play"
	pause_mode = Node.PAUSE_MODE_PROCESS


func _on_Button_PlayPause_pressed():
	if state == "Play":
		get_tree().paused = true
		state = "Pause"
		set_text("Play")
	else:
		get_tree().paused = false
		state = "Play"
		set_text("Pause")
