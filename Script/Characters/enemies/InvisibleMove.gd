
extends State

export(float) var SPEED = 1000.0
export(float) var MAX_DISTANCE = 1200.0

var direction = Vector2()
var distance = 0.0

const PlayerController = preload("res://Script/Characters/Player.gd")

func enter():
	distance = 0.0
	direction = (owner.target.global_position - owner.global_position).normalized()
	owner.get_node('AnimationPlayer').play('invisible')
	owner.set_particles_active(true)

func exit():
	owner.set_particles_active(false)

func update(delta):
	var velocity = SPEED * direction
	owner.move_and_slide(velocity)
	distance += velocity.length() * delta

	if owner.get_slide_count() > 0:
		var collision = owner.get_slide_collision(0)
		if not collision.collider is PlayerController:
			Global.emit_signal('touch_wall')
		Global.emit_signal('charge_direction_set', direction)
		emit_signal('finished')
	elif distance > MAX_DISTANCE:
		Global.emit_signal('charge_direction_set', Vector2())
