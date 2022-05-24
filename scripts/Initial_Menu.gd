extends Node2D


func _ready():
	OS.set_window_maximized(true)

var delta_acc = 0
var max_popup_time = 1

func _process(delta):
	delta_acc += delta
	if delta_acc >= max_popup_time:
		delta_acc = 0
		$Connection_Popup.hide()
	if Network.is_connection_established():
		$Connect_Button.set_text("Disconnect")
		$Profile_Button.disabled = false
	else:
		$Connect_Button.set_text("Connect")
		$Profile_Button.disabled = true
		
	if Network.get_online_player_info() != null:
		$Profile_Button.set_text("Profile")
		$WindowDialog_Login.hide()
	else:
		$Profile_Button.set_text("Log in")
	
	if Network.is_connection_established() and Network.get_online_player_info() != null:
		$Coop_mode_Button.disabled = false
	else:
		$Coop_mode_Button.disabled = true


func _on_Story_mode_Button_pressed():
	Global.goto_scene("res://scenes/Stage_1.tscn")


func _on_Configuration_Button_pressed():
	Global.goto_scene("res://scenes/Configuration_Menu.tscn")


func _on_Coop_mode_Button_pressed():
	Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "co-op")


func _on_Connect_pressed():
	if !Network.is_connection_established():
		$Connection_Popup/Label.set_text("Connecting to server...")
		Network.init_connection()
	else:
		$Connection_Popup/Label.set_text("Disconnecting from server...")
		Network.close_connection()
	$Connection_Popup.popup()


func _on_Profile_pressed():
	if Network.get_online_player_info() != null:
		Global.goto_scene("res://scenes/Profile_Menu.tscn")
	else:
		$WindowDialog_Login.popup()


func _on_Submit_Credentials_Button_pressed():
	var username = $WindowDialog_Login/Username_LineEdit.get_text()
	var password = $WindowDialog_Login/Password_LineEdit.get_text()
	if username.strip_edges() != "" and password.strip_edges() != "":
		Network.s_login(username, password)
