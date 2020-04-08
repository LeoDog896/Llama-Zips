extends RigidBody2D

var isGrabbed = false
var to_trigger_click = false
var pos
var mouse_pos
var origin

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
		global_rotation = 0
		self.collision_layer = 0
		self.collision_mask = 0
		self.mode = RigidBody2D.MODE_STATIC
		self.sleeping = true
		isGrabbed = true
	elif isGrabbed:
		pos = player.position
		mouse_pos = (get_global_mouse_position() - self.position).normalized()
		
		if player_sprite.flip_h:
			global_transform.origin = player.position + Vector2(-80, 0)
			mouse_pos.x = -abs(mouse_pos.x)
		else:
			global_transform.origin = player.position + Vector2(80, 0)
			mouse_pos.x = abs(mouse_pos.x)
		self.mode = RigidBody2D.MODE_RIGID
		self.sleeping = false
		isGrabbed = false
		player.position = pos
		self.collision_layer = 1
		self.collision_mask = 1
		self.linear_velocity = mouse_pos * 500
var vector
func _physics_process(_delta):
	print(linear_velocity.y)
	if isGrabbed:
		vector = Vector2(0,0)
		if player_sprite.flip_h:
			vector.x = -32
		else:
			vector.x = 32
		if player_sprite.flip_v:
			vector.y = 16
		else:
			vector.y = -16
		global_transform.origin = player.position + vector
