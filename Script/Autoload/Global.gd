
extends Node

enum { STATUS_NONE, STATUS_INVINCIBLE, STATUS_POISONED, STATUS_STUNNED }


var camera = null ## Global.camera.shake(time, shake)
var can_dash = true
var can_roll = true
var is_dashing
var is_rolling
var can_attack = true
var jump_attacked = false
var on_ground
var sword_count = 0
var sword_time_count = 2
var state_active
var combo = [{
		'damage': 1, 'animation': 'Attack_A', 'effect': null
	}, {
		'damage': 1, 'animation': 'Attack_B', 'effect': null
	}, {
		'damage': 3, 'animation': 'Attack_C', 'effect': null
	}, {
		'damage': 4, 'animation': 'Attack_D', 'effect': null
	},]

###################### NODE ####################
export (NodePath) onready var sword_time = get_node(sword_time) as Timer

###################### SIGNAL ##################
signal attack_finished
signal state_changed(states_stack)
signal direction_changed(new_direction)
signal died()

func _ready():
	sword_time.connect("timeout", self, "_on_SwordTime_timeout")

func _process(delta):
	if sword_count >= 4:
		sword_count = 0

func _on_SwordTime_timeout():
	sword_count = 0
	sword_time.stop()

func state_cooldown(cooldown):
	state_active = false
	yield(get_tree().create_timer(cooldown), "timeout")
	state_active = true

