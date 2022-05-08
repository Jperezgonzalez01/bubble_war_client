extends KinematicBody2D

const BulletScene = preload("res://objects/Bullet.tscn")

const GRAVITY = 500

var player_in_ladder = false
var player_dead = false
var player_won = false

const PLAYER_HEIGHT = 150
const PLAYER_WIDTH = 70

var remote_player_id = 0


func _ready():
	pass


func _physics_process(delta):
	pass


func play_animation(animation_name):
	$AnimationPlayer_Player.play(animation_name)


func set_state(state_name):
	if state_name != $PlayerStateMachine.get_current_state_name():
		$PlayerStateMachine.transition_to(state_name)
		if state_name == "ShootingState":
			$PlayerStateMachine.get_state().set_emit_shoot_true()

func emit_shoot():
	if $PlayerStateMachine.get_current_state_name() == "ShootingState":
			$PlayerStateMachine.get_state().set_emit_shoot_true()


func set_remote_player_id(id:int) -> void:
	remote_player_id = id


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


func _on_ShootingState_fire_weapon():
	var new_bullet = BulletScene.instance()
	owner.add_child(new_bullet)
	new_bullet.set_global_position($Position2D_Weapon.get_global_position())
