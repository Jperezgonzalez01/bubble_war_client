extends Area2D


var player_in_ladder = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func check_player_position(delta):
	if player_in_ladder != null:
		var player_height = player_in_ladder.PLAYER_HEIGHT
		var ladder_height = get_node("Sprite").texture.get_height()
		var margin_y = (player_height / 2) + (ladder_height / 2) + 5
		var ladder_width = get_node("Sprite").texture.get_width()
		var player_width = player_in_ladder.PLAYER_WIDTH
		var margin_x = (ladder_width / 2) + 20
		if MovementUtils.objects_on_same_position(get_global_position(), player_in_ladder.get_global_position(), margin_x, margin_y):
			player_in_ladder.set_in_ladder(true)
		else:
			player_in_ladder.set_in_ladder(false)
			player_in_ladder = null


func on_body_entered(body):
	if body.is_in_group("players"):
		player_in_ladder = body
