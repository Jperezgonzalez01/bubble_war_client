extends Node2D

const BubbleLargeScene = preload("res://objects/Bubble_Large.tscn")
const max_bubbles_count = 2
var rng = RandomNumberGenerator.new()
var bubbles_array = []

# Initial remote variables (established by server)
var initial_bubble_position = Vector2()
var player_id = 0
var other_players = []
var game_id = 0
var initial_player_positions = {}

var initialized = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Network.set_current_online_scene_id(get_instance_id())


func init_player_positions():
	$KinematicBody2D_Player.set_position(initial_player_positions[player_id])
	$KinematicBody2D_Player.set_current_game_id(game_id)
	$KinematicBody2D_Remote_Player.set_remote_player_id(other_players[0])
	$KinematicBody2D_Remote_Player.set_position(initial_player_positions[other_players[0]])
	$KinematicBody2D_Player.add_collision_exception_with($KinematicBody2D_Remote_Player)
	$KinematicBody2D_Remote_Player.add_collision_exception_with($KinematicBody2D_Player)
	initialized = true


func _process(delta):
	if !initialized:
		create_two_bubbles(BubbleLargeScene, initial_bubble_position)
		init_player_positions()
	var player_position = $KinematicBody2D_Player.get_position()
	var player_state = $KinematicBody2D_Player.get_current_state()
	Network.s_update_player_position_and_state(game_id, player_position, player_state)
	if $KinematicBody2D_Player.is_player_dead() or $KinematicBody2D_Remote_Player.is_player_dead() \
	or $KinematicBody2D_Player.is_player_winning() or $KinematicBody2D_Remote_Player.is_player_winning():
		Network.s_coop_game_finished(game_id)
		Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "co-op")


func update_player_position_and_state(player_id, player_position, player_state):
	# if we had more than one remote players we may use 'player_id' to identify who is moving
	$KinematicBody2D_Remote_Player.set_position(player_position)
	$KinematicBody2D_Remote_Player.set_state(player_state)


func remote_player_emit_shoot(player_id):
	# if we had more than one remote players we may use 'player_id' to identify who is moving
	$KinematicBody2D_Remote_Player.emit_shoot()

func create_two_bubbles(BubbleSecene, initial_position):
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.RIGHT)
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.LEFT)
	avoid_bubbles_collision()


func delete_bubble(bubble):
	bubbles_array.erase(bubble)
	if bubbles_array.size() == 0:
		$KinematicBody2D_Player.player_won()
		$KinematicBody2D_Remote_Player.player_won()


func create_single_bubble(BubbleSecene, initial_position, initial_direction_x):
	var bubble = BubbleSecene.instance()
	bubble.init(initial_position, initial_direction_x)
	bubbles_array.append(bubble)
	bubble.set_global_position(initial_position)
	self.add_child(bubble)


func avoid_bubbles_collision():
	for i in range(0, bubbles_array.size()):
		for j in range(0, bubbles_array.size()):
			bubbles_array[i].add_collision_exception_with(bubbles_array[j])
