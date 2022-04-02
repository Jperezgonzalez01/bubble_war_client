extends "res://scripts/Bubble_Generic.gd"

var child_scene = preload("res://scenes/Bubble_Medium.tscn")

onready var animation_bubble_large : AnimationPlayer = $AnimationPlayer_Bubble_Large

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_bubble_large.connect("animation_finished", self, "destroy_bubble")
	animation_bubble_large.play("Bouncing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_bubble_large.get_current_animation() == "Bouncing":
		calculate_movement(delta)


func _integrate_forces(state):
	limit_speed(state)


func _on_RigidBody2D_Bubble_body_entered(body):
	collision_detected(body)


func _on_RigidBody2D_Bubble_Large_bubble_destroyed():
	set_sleeping(true)
	gravity_scale = 0
	animation_bubble_large.play("Exploding")
	get_parent().create_two_bubbles(child_scene, get_position())


func destroy_bubble(animation_name):
	if animation_name == "Exploding":
		get_parent().delete_bubble(self)
		queue_free()
