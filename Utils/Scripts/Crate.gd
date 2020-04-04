extends RigidBody2D

var isGrabbed = false

onready var player : KinematicBody2D = get_node("./../Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		call_deferred("on_click")

func _process(delta):
	print(self.position)
	if isGrabbed:
		self.position = player.position

func on_click():
	self.get_parent().remove_child(self)
	player.add_child(self)
	self.position = player.position
	self.collision_layer = 0
	self.collision_mask = 0
	self.mode = MODE_STATIC
	self.sleeping = true
	isGrabbed = true
	print(get_parent())
