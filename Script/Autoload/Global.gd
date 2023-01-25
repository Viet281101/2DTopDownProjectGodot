
extends Node

const DEFAULT_MASS : float = 2.0
const DEFAULT_SLOW_RADIUS : float = 200.0
const DEFAULT_MAX_SPEED : float = 300.0

enum { STATUS_NONE, STATUS_INVINCIBLE, STATUS_POISONED, STATUS_STUNNED }

var camera = null ## Global.camera.shake(time, shake)
var player setget ,_get_player
var health : int = 0
var warrior_speed : int = 0
var can_dash : bool = true
var can_roll : bool= true
var is_dashing : bool
var is_rolling : bool
var can_attack : bool = true
var jump_attacked : bool = false
var on_ground : bool
var sword_count : int = 0
var sword_time_count : int = 2
var hurt_count : int = 0
var state_active : bool
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

signal invincible_started
signal invincible_ended

#### Enemies Signals
signal charge_direction_set(direction)
signal touch_wall()

func _ready() -> void:
	sword_time.connect("timeout", self, "_on_SwordTime_timeout")

func _process(_delta : float) -> void:
	if sword_count >= 4:
		sword_count = 0
	if hurt_count >= 2:
		hurt_count = 0

func _get_player():
	return player if is_instance_valid(player) else null

func _on_SwordTime_timeout() -> void:
	sword_count = 0
	sword_time.stop()

func state_cooldown(cooldown : float) -> void:
	state_active = false
	yield(get_tree().create_timer(cooldown), "timeout")
	state_active = true

