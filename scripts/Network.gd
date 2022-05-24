extends Node


var SERVER_PORT = 5008
var SERVER_IP = "127.0.0.1"

var connection_established = false
var online_game_ready : bool = false
var current_online_scene_id = null
var online_player_info = null

func init_connection():
	var client = NetworkedMultiplayerENet.new()
	client.create_client(SERVER_IP, SERVER_PORT)
	get_tree().set_network_peer(client)
	
	client.connect("connection_succeeded", self, "_connection_succeeded");
	client.connect("connection_failed", self, "_connection_failed");
	client.connect("network_peer_disconnected", self, "_network_peer_disconnected");


## Default signals ##

func _connection_succeeded():
	print("Connection succeeded")
	connection_established = true


func _connection_failed():
	print("Connection failed")
	connection_established = false
	online_player_info = null


func _network_peer_disconnected():
	print("Disconnected from server")
	connection_established = false
	online_player_info = null


## Call to server Functions ##

func s_refresh_lobbies(requester):
	rpc_id(1, "s_refresh_lobbies", requester)

func s_get_my_lobby(requester):
	rpc_id(1, "s_get_my_lobby", requester)

func s_create_lobby():
	rpc_id(1, "s_create_lobby")

func s_add_player_to_lobby(new_lobby_id):
	rpc_id(1, "s_add_player_to_lobby", new_lobby_id)

func s_leave_current_lobby():
	rpc_id(1, "s_leave_current_lobby")

func s_create_new_coop_stage():
	rpc_id(1, "s_create_new_coop_stage")

func s_update_player_position_and_state(game_id, player_position, player_state):
	rpc_id(1, "s_update_player_position_and_state", game_id, player_position, player_state)

func s_player_emit_shoot(game_id, bullet_index, bullet_position):
	rpc_id(1, "s_player_emit_shoot", game_id, bullet_index, bullet_position)

func s_coop_game_finished(game_id):
	rpc_id(1, "s_coop_game_finished", game_id)

func s_destroy_bullet(game_id, bullet_index):
	rpc_id(1, "s_destroy_bullet", game_id, bullet_index)

func s_destroy_bubble(game_id, bubble_index, bubble_position):
	rpc_id(1, "s_destroy_bubble", game_id, bubble_index, bubble_position)

func s_destroy_platform(game_id, platform_index):
	rpc_id(1, "s_destroy_platform", game_id, platform_index)

func s_login(username, password):
	rpc_id(1, "s_login", username, password)

func s_update_player_score(user_id, score):
	rpc_id(1, "s_update_player_score", user_id, score)

func s_get_all_boosts(requester):
	rpc_id(1, "s_get_all_boosts", requester)

func s_update_player_info(user_id):
	rpc_id(1, "s_update_player_info", user_id)

func s_update_selected_boost(user_id, selected_boost):
	rpc_id(1, "s_update_selected_boost", user_id, selected_boost)

## Remote Functions ##

remote func c_get_my_lobby(lobby_response, requester):
	instance_from_id(requester).update_lobby(lobby_response)

remote func c_refresh_lobbies(lobbies, requester):
	instance_from_id(requester).set_available_lobbies(lobbies)

remote func c_online_game_ready():
	online_game_ready = true

remote func c_online_game_not_ready():
	online_game_ready = false

remote func c_start_coop_stage(game_id, player_id, initial_bubble_position, other_players, initial_player_positions):
	Global.goto_scene_modifying_variables("res://scenes/Co-Op_Stage_1.tscn",\
	["game_id", "player_id", "initial_bubble_position", "other_players", "initial_player_positions"],\
	[game_id, player_id, initial_bubble_position, other_players, initial_player_positions])

remote func c_update_player_position_and_state(player_id, player_position, player_state):
	instance_from_id(current_online_scene_id).update_player_position_and_state(player_id, player_position, player_state)

remote func c_player_emit_shoot(player_id, bullet_index, bullet_position):
	instance_from_id(current_online_scene_id).remote_player_emit_shoot(player_id, bullet_index, bullet_position)

remote func c_destroy_bullet(bullet_index):
	instance_from_id(current_online_scene_id).destroy_remote_bullet(bullet_index)

remote func c_destroy_bubble(bubble_index, bubble_position):
	instance_from_id(current_online_scene_id).destroy_remote_bubble(bubble_index, bubble_position)

remote func c_destroy_platform(platform_index):
	instance_from_id(current_online_scene_id).destroy_remote_platform(platform_index)

remote func c_get_all_boosts(boosts_list, requester):
	instance_from_id(requester).set_boosts_list(boosts_list)

remote func c_update_player_info(user_info):
	online_player_info = user_info

## Internal Functions ##

func is_connection_established() -> bool:
	return connection_established


func close_connection():
	get_tree().set_network_peer(null)
	connection_established = false
	online_player_info = null


func is_online_game_ready() -> bool:
	return online_game_ready

func set_current_online_scene_id(scene_id):
	current_online_scene_id = scene_id

func get_current_online_scene_id():
	return current_online_scene_id

func get_online_player_info():
	return online_player_info
