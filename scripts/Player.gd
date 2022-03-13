extends KinematicBody2D

const BulletScene = preload("res://scenes/Bullet.tscn")

const GRAVITY = 500
var gravity_velocity = Vector2()


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Simulate gravity. The character will move down until he reaches another object and collide
	gravity_velocity.y += delta * GRAVITY
	var gravity_motion = gravity_velocity * delta
	move_and_collide(gravity_motion)


func is_in_group(group:String):
	return group == "players"


func _on_ShootingState_fire_weapon():
	var new_bullet = BulletScene.instance()
	owner.add_child(new_bullet)
	new_bullet.set_global_position($Position2D_Weapon.get_global_position())
