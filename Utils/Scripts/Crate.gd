extends RigidBody2D

var isGrabbed = false
var to_trigger_click = false
var pos

onready var player : KinematicBody2D = get_node("./../Player")
onready var player_sprite : AnimatedSprite = get_node("./../Player/AnimatedSprite")

func _input_event(_viewport, event, _shape_idx):
	if Input.is_action_pressed("ui_left_mouse") and not isGrabbed:
		pick()

func _input(event):
	if Input.is_action_pressed("ui_left_mouse") and isGrabbed:
		pick()

func pick():
	if not isGrabbed:
		self.collision_layer = 0
		self.collision_mask = 0
		self.mode = RigidBody2D.MODE_STATIC
		self.sleeping = true
		isGrabbed = true
	elif isGrabbed:
		pos = player.position
		if player_sprite.flip_h:
			global_transform.origin = player.position + Vector2(-80, 0)
		else:
			global_transform.origin = player.position + Vector2(80, 0)
		self.mode = RigidBody2D.MODE_RIGID
		self.sleeping = false
		isGrabbed = false
		player.position = pos
		self.collision_layer = 1
		self.collision_mask = 1
		self.linear_velocity = (get_global_mouse_position() - self.position).normalized() * 500

func _physics_process(_delta):
	if isGrabbed:
		if player_sprite.flip_h:
			global_transform.origin = player.position + Vector2(-32, -16)
		else:
			global_transform.origin = player.position + Vector2(32, -16)
