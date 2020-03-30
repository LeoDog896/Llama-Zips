extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 400
export var gravity : float = 2000

onready var camera : Camera2D = get_node("Camera")
onready var sprite : Sprite   = get_node("Sprite")
var can_jump = true
var can_fullscreen = true
var collision

func _ready():
	set_process_input(true)


func _physics_process(delta):
	velocity.y += delta * gravity
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -600
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  speed
	else:
		velocity.x = 0

	move_and_slide(velocity, Vector2(0, -1))

func _process(_delta):
	if velocity.x < 0:
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		sprite.set_flip_h(false)

func _input(event):
	if event is InputEventKey and event.scancode == KEY_F11:
		if event.pressed:
			if can_fullscreen:
				OS.window_fullscreen = !OS.window_fullscreen
				can_fullscreen = false
		else:
			can_fullscreen = true
