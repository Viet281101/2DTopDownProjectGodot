extends Node2D
class_name AnimationEffect

func _ready():
	pass

func _process(_delta):
	yield($AnimationPlayer, "animation_finished")
	queue_free()

