extends KinematicBody2D

const BulletScene = preload("res://objects/Bullet.tscn")

const GRAVITY = 500

var player_in_ladder = false
var player_dead = false
var player_won = false

const PLAYER_HEIGHT = 150
const PLAYER_WIDTH = 70

var current_game_id = 0

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Simulate gravity. The character will move down until he reaches another object and collide
	if !is_in_ladder():
		move_and_slide(Vector2(0, GRAVITY), Vector2.UP)

func set_current_game_id(id:int) -> void:
	current_game_id = id


func is_in_group(group:String):
	return group == "players"


func is_in_ladder() -> bool:
	return player_in_ladder


func set_in_ladder(state:bool):
	player_in_ladder = state


func player_died():
	player_dead = true
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true


func is_player_dead():
	return player_dead


func player_won():
	player_won = true
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true


func is_player_winning():
	return player_won


func get_current_animation():
	return $AnimationPlayer_Player.current_animation


func get_current_state():
	return $PlayerStateMachine.get_current_state_name()


func _on_ShootingState_fire_weapon():
	var online_player_info = Network.get_online_player_info()
	
	# Online play (coop or versus)
	if current_game_id != 0:
		var new_bullet = create_new_bullet(Vector2(0, 1), 0)
		new_bullet.connect("bullet_destoyed", owner, "send_destroy_remote_bullet")
		owner.local_bullets_array.append(new_bullet)
		var index = owner.local_bullets_array.find(new_bullet)
		Network.s_player_emit_shoot(current_game_id, index, $Position2D_Weapon.get_global_position())
	# Offline play (story mode)
	# Story mode loged in
	elif online_player_info != null:
		# Double shoot boost
		if online_player_info["SELECTED_BOOST_NAME"] == "Double shoot":
			create_new_bullet(Vector2(0.33, 1), -0.58)
			create_new_bullet(Vector2(-0.33, 1), 0.58)
		# Triple shoot boost
		elif online_player_info["SELECTED_BOOST_NAME"] == "Triple shoot":
			create_new_bullet(Vector2(0.33, 1), -0.58)
			create_new_bullet(Vector2(0, 1), 0)
			create_new_bullet(Vector2(-0.33, 1), 0.58)
		# No shoot boost
		else:
			create_new_bullet(Vector2(0, 1), 0)
	# Story mode not loged in
	else:
		create_new_bullet(Vector2(0, 1), 0)


func create_new_bullet(direction_vector, rotation_radians):
	var new_bullet = BulletScene.instance()
	owner.add_child(new_bullet)
	new_bullet.set_global_position($Position2D_Weapon.get_global_position())
	new_bullet.direction = direction_vector
	new_bullet.rotate(rotation_radians)
	return new_bullet
