extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 400
export var gravity : float = 2000

onready var camera    : Camera2D         = get_node("Camera2D")
onready var sprite    : Sprite           = get_node("Sprite")
onready var collision : CollisionShape2D = get_node("CollisionShape2D")

onready var raycast   : RayCast2D        = get_node("RayCast2D")

var can_jump = true
var can_fullscreen = true

var isGrappling = false
var grapplingVelocity

func _ready():
	set_process_input(true)

var player_aim

func _physics_process(delta):
	print(isGrappling)
	if isGrappling:
		player_aim = Vector2(5,5).normalized() * 10
		self.position = self.position.clamped(16)
		move_and_slide(player_aim)
	else:
		velocity.y += delta * gravity
		if Input.is_action_pressed("ui_left"):
			velocity.x = -speed
			self.frame = self.frame + 1
		elif Input.is_action_pressed("ui_right"):
			velocity.x =  speed
			self.frame = self.frame + 1
		else:
			velocity.x = 0
			self.frame = 0
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y = -680
		elif is_on_floor():
			velocity.y = 0
		move_and_slide(velocity, Vector2(0, -1))
	if Input.is_action_just_pressed("grapple"):
		switchbody()

func _process(_delta):
	if velocity.x < 0:
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		sprite.set_flip_h(false)
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -680

var collision_point

func switchbody():
	if !isGrappling:
		raycast.cast_to = get_local_mouse_position()
		raycast.enabled = true
		if raycast.is_colliding():
			collision_point = raycast.get_collision_point()
			isGrappling = true
			grapplingVelocity = collision_point.normalized()
	else:
		isGrappling = false

func _input(event):
	if event is InputEventKey and event.scancode == KEY_F11:
		if event.pressed:
			if can_fullscreen:
				OS.window_fullscreen = !OS.window_fullscreen
				can_fullscreen = false
		else:
			can_fullscreen = true
