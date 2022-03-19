extends Node

enum { STATUS_NONE, STATUS_INVINCIBLE, STATUS_POISONED, STATUS_STUNNED }

var can_dash = true
var is_dashing
var on_ground

signal attack_finished

func _ready():
	pass
