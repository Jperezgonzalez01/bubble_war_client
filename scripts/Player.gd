extends KinematicBody2D

const BulletScene = preload("res://scenes/Bullet.tscn")

const GRAVITY = 500

var player_in_ladder = false

const PLAYER_HEIGHT = 150
const PLAYER_WIDTH = 75


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Simulate gravity. The character will move down until he reaches another object and collide
	if !is_in_ladder():
		move_and_slide(Vector2(0, GRAVITY), Vector2.UP)


func is_in_group(group:String):
	return group == "players"


func is_in_ladder() -> bool:
	return player_in_ladder


func set_in_ladder(state:bool):
	player_in_ladder = state


func _on_ShootingState_fire_weapon():
	var new_bullet = BulletScene.instance()
	owner.add_child(new_bullet)
	new_bullet.set_global_position($Position2D_Weapon.get_global_position())
