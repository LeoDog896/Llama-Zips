extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 400
export var gravity : float = 2000

onready var camera    : Camera2D    = get_node("Camera2D")
onready var sprite    : Sprite      = get_node("Sprite")

onready var rigid     : RigidBody2D = get_node("./../PlayerRid")
onready var rigid_cam : Camera2D    = get_node("./../PlayerRid/Camera2D")
onready var rigid_spr : Sprite      = get_node("./../PlayerRid/Sprite")

onready var joint     = get_node("./../Joint")

var can_jump = true
var can_fullscreen = true
var collision

func _ready():
	set_process_input(true)

var thing = false

func _physics_process(delta):
	velocity.y += delta * gravity
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  speed
	else:
		velocity.x = 0
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -600
	elif is_on_floor():
		velocity.y = 0
	move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):
	if velocity.x < 0:	
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		sprite.set_flip_h(false)
	if Input.is_action_just_pressed("grapple"):
		switchbody(thing)
		thing = !thing

func switchbody(toWhom): #false = switch to rigid
	if toWhom:
		rigid.set_pos(self.position.x, self.position.y)
		joint.length = sqrt(abs(self.position.x - rigid.position.x) + abs(self.position.y - rigid.position.y))
		sprite.visible = false
		camera.current = false
		rigid_spr.visible = true
		rigid_cam.current = true
		rigid.linear_velocity.x = velocity.x
		rigid.linear_velocity.y = 0
	else:
		self.position = rigid.position
		joint.length = sqrt(abs(self.position.x - rigid.position.x) + abs(self.position.y - rigid.position.y))
		sprite.visible = true
		camera.current = true
		rigid_spr.visible = false
		rigid_cam.current = false
		velocity.x = rigid.linear_velocity.x
		velocity.y = 0

func _input(event):
	if event is InputEventKey and event.scancode == KEY_F11:
		print("e")
		#if event.pressed:
			#if can_fullscreen:
				#OS.window_fullscreen = !OS.window_fullscreen
				#can_fullscreen = false
		#else:
			#can_fullscreen = true
