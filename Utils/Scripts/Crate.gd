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

func _process(delta):
	if isGrabbed:
		if player_sprite.flip_h:
			self.position = player.position + Vector2(-32, -16)
		else:
			self.position = player.position + Vector2(32, -16)
	if not isGrabbed and to_trigger_click:
		self.collision_layer = 0
		self.collision_mask = 0
		self.mode = MODE_STATIC
		self.sleeping = true
		isGrabbed = true
	elif isGrabbed and to_trigger_click:
		var xform = Physics2DServer.body_get_state(self.get_rid(), Physics2DServer.BODY_STATE_LINEAR_VELOCITY)
		
		if player_sprite.flip_h:
			xform.origin = player.position + Vector2(-80, -16)
		else:
			xform.origin = player.position + Vector2(80, -16)
			
		Physics2DServer.body_set_state(self.get_rid(), Physics2DServer.BODY_STATE_LINEAR_VELOCITY, xform)
		self.collision_layer = 1
		self.collision_mask = 1
		self.mode = MODE_RIGID
		self.sleeping = false
		isGrabbed = false

func _integrate_forces(state):
	if to_trigger_click and isGrabbed:
		var xform = state.get_transform()
		state.set_transform(xform)
		if player_sprite.flip_h:
			xform.origin = player.position + Vector2(-80, -16)
		else:
			xform.origin = player.position + Vector2(80, -16)
		self.collision_layer = 1
		self.collision_mask = 1
		self.mode = MODE_RIGID
		self.sleeping = false
		isGrabbed = false
