# Virtual base class for all states.
class_name PlayerState
extends State

const WALK_SPEED = 500
const CLIMB_SPEED = 500

var animation_player = null
var kinematic_player = null

var state_name = ""

func get_state_name():
	return state_name
