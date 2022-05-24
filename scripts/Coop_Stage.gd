extends Node2D

const BubbleLargeScene = preload("res://objects/Bubble_Large.tscn")
const max_bubbles_count = 2
var rng = RandomNumberGenerator.new()
var bubbles_array = []
var destructible_platforms_array = []
var delta_acc = 0
var score = 0
var bubble_score = 0
var time_score = 0

# Initial remote variables (established by server)
var initial_bubble_position = Vector2()
var player_id = 0
var other_players = []
var game_id = 0
var initial_player_positions = {}
var local_bullets_array = []
var remote_bullets_dict = {}

var initialized = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() != "Android":
		$Android_Button.hide()
		$Android_Joystick.hide()
	Network.set_current_online_scene_id(get_instance_id())
	$StaticBody2D_destructible_platform_small_1.connect("platform_destroyed", self, "send_platform_destroyed")
	$StaticBody2D_destructible_platform_small_2.connect("platform_destroyed", self, "send_platform_destroyed")
	$StaticBody2D_destructible_platform_small_3.connect("platform_destroyed", self, "send_platform_destroyed")
	$StaticBody2D_destructible_platform_small_4.connect("platform_destroyed", self, "send_platform_destroyed")
	$StaticBody2D_destructible_platform_small_5.connect("platform_destroyed", self, "send_platform_destroyed")
	destructible_platforms_array.append($StaticBody2D_destructible_platform_small_1)
	destructible_platforms_array.append($StaticBody2D_destructible_platform_small_2)
	destructible_platforms_array.append($StaticBody2D_destructible_platform_small_3)
	destructible_platforms_array.append($StaticBody2D_destructible_platform_small_4)
	destructible_platforms_array.append($StaticBody2D_destructible_platform_small_5)


func _exit_tree():
	Network.set_current_online_scene_id(null)


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
	delta_acc += delta
	if delta_acc > 0.5:
		delta_acc = 0
		var current_time_left = int($Timer_lbl/Timer.get_time_left())
		time_score = current_time_left * 100
		score = time_score + bubble_score
		$ScoreNumber_Label.set_text(str(score))
		$Timer_lbl.set_text(str(current_time_left))
	$Timer_lbl.set_text(str(int($Timer_lbl/Timer.get_time_left())))
	var player_position = $KinematicBody2D_Player.get_position()
	var player_state = $KinematicBody2D_Player.get_current_state()
	Network.s_update_player_position_and_state(game_id, player_position, player_state)
	if $KinematicBody2D_Player.is_player_dead() or $KinematicBody2D_Remote_Player.is_player_dead():
		Network.s_coop_game_finished(game_id)
		Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "co-op")
	if $KinematicBody2D_Player.is_player_winning() or $KinematicBody2D_Remote_Player.is_player_winning():
		var online_player_info = Network.get_online_player_info()
		if online_player_info != null:
			Network.s_update_player_score(online_player_info["ID"], score)
		Network.s_coop_game_finished(game_id)
		Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "co-op")
	if $Timer_lbl/Timer.get_time_left() == 0:
		$KinematicBody2D_Player.player_died()


func create_two_bubbles(BubbleSecene, initial_position):
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.RIGHT)
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.LEFT)
	avoid_bubbles_collision()


func delete_bubble(bubble):
	bubble_score += 100
	bubbles_array.erase(bubble)
	if bubbles_array.size() == 0:
		$KinematicBody2D_Player.player_won()
		$KinematicBody2D_Remote_Player.player_won()


func create_single_bubble(BubbleSecene, initial_position, initial_direction_x):
	var bubble = BubbleSecene.instance()
	bubble.connect("bubble_destroyed", self, "send_destroy_remote_bubble")
	bubble.init(initial_position, initial_direction_x)
	bubbles_array.append(bubble)
	bubble.set_global_position(initial_position)
	self.add_child(bubble)


func avoid_bubbles_collision():
	for i in range(0, bubbles_array.size()):
		for j in range(0, bubbles_array.size()):
			bubbles_array[i].add_collision_exception_with(bubbles_array[j])




func update_player_position_and_state(player_id, player_position, player_state):
	# if we had more than one remote players we may use 'player_id' to identify who is moving
	$KinematicBody2D_Remote_Player.set_position(player_position)
	$KinematicBody2D_Remote_Player.set_state(player_state)


func remote_player_emit_shoot(player_id, bullet_index, bullet_position):
	# if we had more than one remote players we may use 'player_id' to identify who is moving
	$KinematicBody2D_Remote_Player.emit_shoot()
	$KinematicBody2D_Remote_Player.create_remote_bullet_at_position(bullet_index, bullet_position)


func send_destroy_remote_bullet(bullet):
	var index = local_bullets_array.find(bullet)
	local_bullets_array.erase(bullet)
	Network.s_destroy_bullet(game_id, index)


func destroy_remote_bullet(bullet_index):
	var bullet_to_destroy = remote_bullets_dict[bullet_index]
	bullet_to_destroy.queue_free()
	remote_bullets_dict.erase(bullet_index)


func send_destroy_remote_bubble(bubble):
	var index = bubbles_array.find(bubble)
	Network.s_destroy_bubble(game_id, index, bubble.get_global_position())


func destroy_remote_bubble(bubble_index, bubble_position):
	var bubble_to_destroy = bubbles_array[bubble_index]
	bubble_to_destroy.set_global_position(bubble_position)
	bubble_to_destroy.emit_signal("remote_bubble_destroyed")


func send_platform_destroyed(platform):
	var index = destructible_platforms_array.find(platform)
	Network.s_destroy_platform(game_id, index)


func destroy_remote_platform(platform_index):
	var platform_to_destroy = destructible_platforms_array[platform_index]
	platform_to_destroy.emit_signal("remote_platform_destroyed")
