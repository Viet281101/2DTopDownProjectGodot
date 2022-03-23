extends Node2D

onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start(1)

func _on_Timer_timeout():
	queue_free()
