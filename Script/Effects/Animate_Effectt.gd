
extends Node2D

var dust_type = {
	0: "touch_ground",
	1: "attack_dust",
}

func _process(_delta):
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func animate(type):
	$AnimationPlayer.play(dust_type[type])
