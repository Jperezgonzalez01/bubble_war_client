extends Node2D


func _ready():
	pass


func _on_Story_mode_Button_pressed():
	Global.goto_scene("res://scenes/Stage_1.tscn")


func _on_Configuration_Button_pressed():
	Global.goto_scene("res://scenes/Configuration_Menu.tscn")


func _on_Coop_mode_Button_pressed():
	Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "co-op")


func _on_Versus_mode_Button_pressed():
	Global.goto_scene_modifying_variable("res://scenes/Online_Lobby.tscn", "lobby_type", "versus")
