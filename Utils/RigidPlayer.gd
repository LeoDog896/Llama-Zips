extends RigidBody2D

func _ready():
	pass

var x
var y
var ready = false

func _integrate_forces(state):
	var xform = state.get_transform()
	if ready:
		xform.origin.x = x
		xform.origin.y = y
	state.set_transform(xform)

func set_pos(xx, yy):
	self.x = xx
	self.y = yy
	ready = true
