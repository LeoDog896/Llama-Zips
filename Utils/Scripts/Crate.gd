extends RigidBody2D

var isGrabbed = false

onready var player : KinematicBody2D = get_node("./../Player")
onready var player_sprite : AnimatedSprite = get_node("./../Player/AnimatedSprite")


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		call_deferred("on_click")

func _input(event):
	if event is InputEventMouseButton and event.pressed and isGrabbed and event.button_index == 1:
		call_deferred("on_click")

func _process(delta):
	if isGrabbed:
		if player_sprite.flip_h:
			self.position = player.position + Vector2(-32, -16)
		else:
			self.position = player.position + Vector2(32, -16)

func on_click():
	if isGrabbed:
		self.collision_layer = 1
		self.collision_mask = 1
		self.mode = MODE_RIGID
		self.sleeping = false
		isGrabbed = false
	else:
		self.collision_layer = 0
		self.collision_mask = 0
		self.mode = MODE_STATIC
		self.sleeping = true
		isGrabbed = true
