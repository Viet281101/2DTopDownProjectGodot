extends State

export(float) var MASS = 4.0
export(float) var SLOW_RADIUS = 200.0
export(float) var MAX_SPEED = 300.0
export(float) var ARRIVE_DISTANCE = 6.0

var velocity = Vector2()

func enter():
	owner.get_node('AnimationPlayer').play('idle')
