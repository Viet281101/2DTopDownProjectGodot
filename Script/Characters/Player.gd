extends KinematicBody2D
class_name Player

signal state_changed
signal direction_changed(new_direction)

var look_direction = Vector2(1, 0) setget set_look_direction



func _ready():
	pass



func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)
