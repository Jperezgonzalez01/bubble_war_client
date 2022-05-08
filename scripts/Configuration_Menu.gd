extends Node2D


func _ready():
	GuiKeyBinding.setup_keys()


func _on_Back_Button_pressed():
	Global.goto_scene("res://scenes/Initial_Menu.tscn")
