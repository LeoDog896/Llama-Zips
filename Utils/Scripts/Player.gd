extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 300
export var gravity : float = 490
export var jump    : float = 305

onready var camera    : Camera2D         = get_node("Camera2D")
onready var sprite    : AnimatedSprite   = get_node("AnimatedSprite")

var can_jump = true
var can_fullscreen = true


func _ready():
	set_process_input(true)

var player_aim
var gravity_reverse = false
func set_gravity_vector_normal():
	gravity_reverse = false
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0, 1))

func set_gravity_vector_reverse():
	gravity_reverse = true
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0, -1))

func toggle_gravity():
	if gravity_reverse:
		set_gravity_vector_normal()
	else:
		set_gravity_vector_reverse()

func _physics_process(delta):
	if gravity_reverse:
		velocity.y -= delta * gravity
		sprite.set_flip_v(true)
		move_and_slide(velocity, Vector2(0, 1), false, 4, 0.785398, false)
	else:
		velocity.y += delta * gravity
		sprite.set_flip_v(false)
		move_and_slide(velocity, Vector2(0, -1), false, 4, 0.785398, false)
	if is_on_floor():
		can_jump = true
	else:
		can_jump = false
	if Input.get_action_strength("ui_left"):
		velocity.x = -speed
		if Input.get_action_strength("ui_shift"):
			velocity.x = -speed - 100
			if can_jump:
				sprite.play("running")
		elif can_jump:
			sprite.play("walking")
	elif Input.get_action_strength("ui_right"):
		velocity.x =  speed
		if Input.get_action_strength("ui_shift"):
			velocity.x = speed + 100
			if can_jump:
				sprite.play("running")
		elif can_jump:
			sprite.play("walking")
	else:
		velocity.x = 0
		if can_jump:
			sprite.play("standing")
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -jump
	if Input.is_action_just_pressed("gravity_switch"):
		toggle_gravity()
	elif is_on_floor():
		velocity.y = 0
	var collision = move_and_collide(velocity * delta)
	if collision and collision.collider.name == "Crate":
		var reflect = collision.remainder.bounce(collision.normal)
		velocity = velocity.bounce(collision.normal)
		move_and_collide(reflect)
	check()
func _process(_delta):
	if velocity.x < 0:
		sprite.set_flip_h(true)
	elif velocity.x > 0:
		sprite.set_flip_h(false)
	if Input.is_action_pressed("ui_up") and is_on_floor():
		if gravity_reverse:
			velocity.y = jump
		else:
			velocity.y = -jump

func _input(event):
	if event is InputEventKey and event.scancode == KEY_F11:
		if event.pressed:
			if can_fullscreen:
				OS.window_fullscreen = !OS.window_fullscreen
				can_fullscreen = false
		else:
			can_fullscreen = true
			
func check():
	if not is_on_floor():
		sprite.play("jumping")
