
extends Node2D

var dust_type = {
	0: "touch_ground",
	1: "attack_dust",
}

var type_count = 0

func _ready():
	$AnimationPlayer.play(dust_type[type_count])

func _process(_delta):
	yield($AnimationPlayer, "animation_finished")
	queue_free()

