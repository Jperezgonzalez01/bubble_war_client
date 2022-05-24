# Virtual base class for all states.
class_name PlayerState
extends State

var WALK_SPEED = 500
var CLIMB_SPEED = 500

var animation_player = null
var kinematic_player = null

var state_name = ""

func _ready():
	var online_player_info = Network.get_online_player_info()
	var online_game = Network.get_current_online_scene_id()
	if online_player_info != null and online_game == null:
		if online_player_info["SELECTED_BOOST_NAME"] == "Speed x1.5":
			WALK_SPEED = WALK_SPEED * 1.5
			CLIMB_SPEED = CLIMB_SPEED * 1.5
		elif online_player_info["SELECTED_BOOST_NAME"] == "Speed x2":
			WALK_SPEED = WALK_SPEED * 2
			CLIMB_SPEED = CLIMB_SPEED * 2

func get_state_name():
	return state_name
