extends "res://scripts/Bubble_Generic.gd"


onready var animation_bubble_small : AnimationPlayer = $AnimationPlayer_Bubble_Small

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_bubble_small.connect("animation_finished", self, "destroy_bubble")
	animation_bubble_small.play("Bouncing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_bubble_small.get_current_animation() == "Bouncing":
		calculate_movement(delta)


func _on_RigidBody2D_Bubble_body_entered(body):
	collision_detected(body)


func _on_RigidBody2D_Bubble_Small_bubble_destroyed():
	set_sleeping(true)
	gravity_scale = 0
	animation_bubble_small.play("Exploding")


func destroy_bubble(animation_name):
	if animation_name == "Exploding":
		get_parent().delete_bubble(self)
		queue_free()
