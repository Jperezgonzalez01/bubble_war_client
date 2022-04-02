extends "res://scripts/Ladder_Generic.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_player_position(delta)


func _on_Ladder_Large_body_entered(body):
	on_body_entered(body)
