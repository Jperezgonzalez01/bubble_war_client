extends "res://scripts/Destructible_Platform_Generic.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Destructible_Platform_Large_platform_destroyed():
	destroy_platform()
