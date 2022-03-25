
extends State

signal charge_direction_set(direction)

export(float) var SPEED = 1000.0
export(float) var MAX_DISTANCE = 1200.0

var direction = Vector2()
var distance = 0.0

func enter():
	distance = 0.0
	direction = (owner.target.global_position - owner.global_position).normalized()
	owner.get_node('AnimationPlayer').play('invisible')
	owner.set_particles_active(true)
