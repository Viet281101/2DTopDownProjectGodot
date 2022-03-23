extends KinematicBody2D
class_name Actor, "res://assets/world/decorate/statue_sword.png"

signal position_changed(new_position)

onready var health = $Health

var look_direction = Vector2(1, 0) setget set_look_direction

func take_damage_from(damage_source):
	health.take_damage(damage_source.damage)

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionShape2D.call_deferred("set", "disabled", value)
	Global.emit_signal('died')

func set_look_direction(value):
	look_direction = value
	Global.emit_signal("direction_changed", value)

func reset(target_global_position):
	global_position = target_global_position

func _exit_tree():
	queue_free()

