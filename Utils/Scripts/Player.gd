extends KinematicBody2D

var velocity : Vector2 = Vector2(0,0)

export var speed   : float = 400
export var gravity : float = 2000

onready var camera    : Camera2D         = get_node("Camera2D")
onready var sprite    : AnimatedSprite   = get_node("AnimatedSprite")
onready var collision : CollisionShape2D = get_node("CollisionShape2D")
onready var raycast   : RayCast2D        = get_node("RayCast2D")


var can_jump = true
var can_fullscreen = true

var isGrappling = false
var grapplingVelocity
var grapplingPoint

func _ready():
	
	set_process_input(true)

var player_aim

func _physics_process(delta):
	if isGrappling:
		position = position.clamped(grapplingPoint + 300)
	velocity.y += delta * gravity
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		sprite.play("walking")
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  speed
		sprite.play("walking")
	else:
		velocity.x = 0
		sprite.play("standing")
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -680
	elif is_on_floor():
		velocity.y = 0
	move_and_slide(velocity, Vector2(0, -1), false, 4, 0.785398, false)
#	var collision = move_and_collide(velocity * delta)
#	if collision:
#		var reflect = collision.remainder.bounce(collision.normal)
#		velocity = velocity.bounce(collision.normal)
#		move_and_collide(reflect)
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
			print(collision_point)
			grapplingPoint = collision_point
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
