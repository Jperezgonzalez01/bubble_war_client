extends Node2D

var lobby_type = ""
var delta_count = 0
var current_lobby_id = 0
var player_info = {"lobby_id": 0, "current_lobby_players": []}
var other_lobbies = []
var selected_lobby = 0


func _ready():
	if !Network.is_connection_established():
		Network.init_connection()


func _process(delta):
	update_buttons()
	
	delta_count += delta
	if delta_count > 0.5:
		Network.s_get_my_lobby(get_instance_id())
		Network.s_refresh_lobbies(get_instance_id())

		#refresh current player lobby
		refresh_local_player_lobby_info()

		# refresh other lobbies list
		refresh_other_lobbies_list()
		
		delta_count = 0


func update_lobby(lobby_response):
	player_info["lobby_id"] = lobby_response[0]
	player_info["current_lobby_players"] = lobby_response[1]


func set_available_lobbies(lobbies):
	other_lobbies = lobbies


func update_buttons():
	if player_info["lobby_id"] == 0:
		$join_to_lobby_btn.set_text("Join to lobby")
		$create_lobby_btn.disabled = false
		$play_btn.disabled = true
		$back_btn.disabled = false
	else:
		$join_to_lobby_btn.set_text("Leave lobby")
		$create_lobby_btn.disabled = true
		$play_btn.disabled = !Network.is_online_game_ready()
		$back_btn.disabled = true


func refresh_local_player_lobby_info():
	current_lobby_id = player_info["lobby_id"]
	var current_lobby_text = "Not in a lobby" if current_lobby_id == 0 else str(current_lobby_id)
	$current_lobby_text.set_text(current_lobby_text)
	$players_in_lobby_list.clear()
	for player_id in player_info["current_lobby_players"]:
		$players_in_lobby_list.add_item(str(player_id))


func refresh_other_lobbies_list():
	$other_lobbies_list.clear()
	for lobby_id in other_lobbies:
		$other_lobbies_list.add_item(str(lobby_id))


func _on_create_join_lobby_btn_pressed():
	Network.s_create_lobby()


func _on_join_to_lobby_btn_pressed():
	if player_info["lobby_id"] == 0:
		if selected_lobby != 0:
			Network.s_add_player_to_lobby(selected_lobby)
	else:
		Network.s_leave_current_lobby()


func _on_other_lobbies_list_item_selected(index):
	selected_lobby = int($other_lobbies_list.get_item_text(index))


func _on_other_lobbies_list_nothing_selected():
	selected_lobby = 0


func _on_play_btn_pressed():
	Network.s_create_new_coop_stage()
	


func _on_back_btn_pressed():
	if Network.is_connection_established():
		Network.close_connection()
	Global.goto_scene("res://scenes/Initial_Menu.tscn")
