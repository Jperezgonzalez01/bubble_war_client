extends Node


const SERVER_PORT = 5008
const SERVER_IP = "127.0.0.1"

var connection_established = false
var online_game_ready : bool = false
var current_online_scene_id = 0

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


func _network_peer_disconnected():
	print("Disconnected from server")
	connection_established = false


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

func s_player_emit_shoot(game_id):
	rpc_id(1, "s_player_emit_shoot", game_id)

func s_coop_game_finished(game_id):
	rpc_id(1, "s_coop_game_finished", game_id)


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

remote func c_player_emit_shoot(player_id):
	instance_from_id(current_online_scene_id).remote_player_emit_shoot(player_id)


## Internal Functions ##

func is_connection_established() -> bool:
	return connection_established


func close_connection():
	get_tree().set_network_peer(null)
	connection_established = false


func is_online_game_ready() -> bool:
	return online_game_ready

func set_current_online_scene_id(scene_id):
	current_online_scene_id = scene_id
