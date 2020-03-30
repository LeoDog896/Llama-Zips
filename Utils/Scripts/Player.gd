extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 400
export var gravity : float = 2000

onready var camera    : Camera2D    = get_node("Camera2D")
onready var sprite    : Sprite      = get_node("Sprite")

onready var rigid     : RigidBody2D = get_node("./../PlayerRid")
onready var rigid_cam : Camera2D    = get_node("./../PlayerRid/Camera2D")
onready var rigid_spr : Sprite      = get_node("./../PlayerRid/Sprite")
var can_jump = true
var can_fullscreen = true
var collision

func _ready():
	set_process_input(true)


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

func switchbody(toWhom): #false = switch to rigid
	if toWhom:
		self.position = rigid.position
		sprite.visible = true
		camera.current = true
		rigid_spr.visible = false
		rigid_cam.current = false
	else:
		rigid.position = self.position
		sprite.visible = false
		camera.current = false
		rigid_spr.visible = true
		rigid_cam.current = true

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			switchbody(false)
	if event is InputEventKey and event.scancode == KEY_F11:
		if event.pressed:
			if can_fullscreen:
				OS.window_fullscreen = !OS.window_fullscreen
				can_fullscreen = false
		else:
			can_fullscreen = true
