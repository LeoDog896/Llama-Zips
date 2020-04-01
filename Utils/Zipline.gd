extends Node2D

func _ready():
	pass # Replace with function body.

func set_end_point(point):
	get_node("StaticBody2D/CollisionShape2D").get_shape().a = point
