extends RigidBody2D

signal bubble_destroyed()

var previous_position
var previous_direction_y
var previous_direction_x
const BOUNCE_IMPULSE_VELOCITY_Y = -50
const BOUNCE_IMPULSE_VELOCITY_X = 100
const INITIAL_IMPULSE_Y = -150
const INITIAL_IMPULSE_X = 300

func init(initial_position:Vector2, initial_direction_x):
	previous_position = initial_position
	previous_direction_y = MovementUtils.DIRECTION_Y.UP

	var impulse_x = INITIAL_IMPULSE_X if initial_direction_x == MovementUtils.DIRECTION_X.RIGHT else -INITIAL_IMPULSE_X
	apply_central_impulse(Vector2(impulse_x, INITIAL_IMPULSE_Y))
	previous_direction_x = initial_direction_x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func calculate_movement(delta):
	var current_position = get_global_position()
	var current_direction_y = MovementUtils.get_direction_y(current_position, previous_position)
	var current_direction_x = MovementUtils.get_direction_x(current_position, previous_position)

	var y_direction_has_changed = MovementUtils.direction_changed(current_direction_y, previous_direction_y)

	if current_direction_y == MovementUtils.DIRECTION_Y.UP and y_direction_has_changed:
		if current_direction_x == MovementUtils.DIRECTION_X.RIGHT:
			apply_central_impulse(Vector2(BOUNCE_IMPULSE_VELOCITY_X, BOUNCE_IMPULSE_VELOCITY_Y))
		elif current_direction_x == MovementUtils.DIRECTION_X.LEFT:
			apply_central_impulse(Vector2(-BOUNCE_IMPULSE_VELOCITY_X, BOUNCE_IMPULSE_VELOCITY_Y))
		else:
			apply_central_impulse(Vector2(BOUNCE_IMPULSE_VELOCITY_X, BOUNCE_IMPULSE_VELOCITY_Y))

	previous_position = current_position
	previous_direction_y = current_direction_y
	previous_direction_x = current_direction_x


func is_in_group(group:String):
	return group == "bubbles"


func collision_detected(body:Node):
	if body.is_in_group("players"):
		get_tree().paused = true
