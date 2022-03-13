extends Sprite

const BubbleLargeScene = preload("res://scenes/Bubble_Large.tscn")
const max_bubbles_count = 2
var rng = RandomNumberGenerator.new()
var bubbles_array = []
var player = null
var player_previous_position_x = null


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var initial_position = Vector2(rng.randi_range(-750, 750), -250)
	create_two_bubbles(BubbleLargeScene, initial_position)


func create_two_bubbles(BubbleSecene, initial_position):
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.RIGHT)
	create_single_bubble(BubbleSecene, initial_position, MovementUtils.DIRECTION_X.LEFT)
	avoid_bubbles_collision()


func delete_bubble(bubble):
	bubbles_array.erase(bubble)


func create_single_bubble(BubbleSecene, initial_position, initial_direction_x):
	var bubble = BubbleSecene.instance()
	bubble.set_global_position(initial_position)
	bubble.init(initial_position, initial_direction_x)
	bubbles_array.append(bubble)
	add_child(bubble)


func avoid_bubbles_collision():
	for i in range(0, bubbles_array.size()):
		for j in range(0, bubbles_array.size()):
			bubbles_array[i].add_collision_exception_with(bubbles_array[j])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
