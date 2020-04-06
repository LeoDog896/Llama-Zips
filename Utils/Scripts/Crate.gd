extends RigidBody2D

var isGrabbed = false
var to_trigger_click = false

onready var player : KinematicBody2D = get_node("./../Player")
onready var player_sprite : AnimatedSprite = get_node("./../Player/AnimatedSprite")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		to_trigger_click = true

func _input(event):
	if event is InputEventMouseButton and event.pressed and isGrabbed and event.button_index == 1:
		to_trigger_click = true

func _physics_process(delta):
	if isGrabbed:
		if player_sprite.flip_h:
			global_transform.origin = player.position + Vector2(-32, -16)
		else:
			global_transform.origin = player.position + Vector2(32, -16)
	if not isGrabbed and to_trigger_click:
		self.collision_layer = 0
		self.collision_mask = 0
		self.mode = RigidBody2D.MODE_STATIC
		self.sleeping = true
		isGrabbed = true
		to_trigger_click = false
	elif isGrabbed and to_trigger_click:
		if player_sprite.flip_h:
			global_transform.origin = player.position + Vector2(-62, -16)
		else:
			global_transform.origin = player.position + Vector2(62, -16)
		self.collision_layer = 1
		self.collision_mask = 1
		self.mode = RigidBody2D.MODE_RIGID
		self.sleeping = false
		isGrabbed = false
		to_trigger_click = false
