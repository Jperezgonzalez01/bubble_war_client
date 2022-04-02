extends StaticBody2D

signal platform_destroyed()


func is_in_group(group:String):
	return group == "destructible_platforms"


func destroy_platform():
	queue_free()
