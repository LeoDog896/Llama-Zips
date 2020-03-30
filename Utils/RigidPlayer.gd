extends RigidBody2D

onready var sprite : Sprite   = get_node("Sprite")
onready var camera : Camera2D = get_node("Camera")

onready var kinem     : RigidBody2D = get_node("./../PlayerKin")
onready var kinem_cam : Camera2D    = get_node("./../PlayerKin/Camera2D")
onready var kinem_spr : Sprite      = get_node("./../PlayerKin/Sprite")

func _ready():
	pass # Replace with function body.
