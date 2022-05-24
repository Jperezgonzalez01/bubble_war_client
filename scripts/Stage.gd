extends Node2D

const BubbleLargeScene = preload("res://objects/Bubble_Large.tscn")
const max_bubbles_count = 2
var rng = RandomNumberGenerator.new()
var bubbles_array = []
var score = 0
var bubble_score = 0
var time_score = 0
var delta_acc = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_name() != "Android":
		$Android_Button.hide()
		$Android_Joystick.hide()
	rng.randomize()
	var initial_position = Vector2(rng.randi_range(210, 1710), 290)
	create_two_bubbles(BubbleLargeScene, initial_position)


func create_two_bubbles(BubbleSecene, initial_position):
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.RIGHT)
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.LEFT)
	avoid_bubbles_collision()


func delete_bubble(bubble):
	bubble_score += 100
	bubbles_array.erase(bubble)
	if bubbles_array.size() == 0:
		$KinematicBody2D_Player.player_won()


func create_single_bubble(BubbleSecene, initial_position, initial_direction_x):
	var bubble = BubbleSecene.instance()
	bubble.init(initial_position, initial_direction_x)
	bubbles_array.append(bubble)
	bubble.set_global_position(initial_position)
	self.add_child(bubble)


func avoid_bubbles_collision():
	for i in range(0, bubbles_array.size()):
		for j in range(0, bubbles_array.size()):
			bubbles_array[i].add_collision_exception_with(bubbles_array[j])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta_acc += delta
	if delta_acc > 0.5:
		delta_acc = 0
		var current_time_left = int($Timer_lbl/Timer.get_time_left())
		time_score = current_time_left * 100
		score = time_score + bubble_score
		$ScoreNumber_Label.set_text(str(score))
		$Timer_lbl.set_text(str(current_time_left))
	if $KinematicBody2D_Player.is_player_dead():
		Global.goto_scene("res://scenes/Initial_Menu.tscn")
	if $KinematicBody2D_Player.is_player_winning():
		var online_player_info = Network.get_online_player_info()
		if online_player_info != null:
			Network.s_update_player_score(online_player_info["ID"], score)
		Global.goto_scene("res://scenes/Initial_Menu.tscn")
	if $Timer_lbl/Timer.get_time_left() == 0:
		$KinematicBody2D_Player.player_died()
