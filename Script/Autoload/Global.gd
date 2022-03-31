
extends Node

const DEFAULT_MASS = 2.0
const DEFAULT_SLOW_RADIUS = 200.0
const DEFAULT_MAX_SPEED = 300.0

enum { STATUS_NONE, STATUS_INVINCIBLE, STATUS_POISONED, STATUS_STUNNED }

var camera = null ## Global.camera.shake(time, shake)
var player = null
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

signal invincible_started
signal invincible_ended

#### Enemies Signals
signal charge_direction_set(direction)
signal touch_wall()

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

func arrive_to(velocity, position, target_position, mass=DEFAULT_MASS, slow_radius=DEFAULT_SLOW_RADIUS, max_speed=DEFAULT_MAX_SPEED):
	"""
	Calculates and returns a new velocity with the arrive steering behavior arrived based on
	an existing velocity (Vector2), the object's current and target positions (Vector2)
	"""
	var distance_to_target = position.distance_to(target_position)

	var desired_velocity = (target_position - position).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25
	var steering = (desired_velocity - velocity) / mass

	return velocity + steering

func follow(velocity, position, target_position, max_speed, mass=DEFAULT_MASS):
	var desired_velocity = (target_position - position).normalized() * max_speed

#	var push = calculate_avoid_force(desired_velocity)
#	var steering = (desired_velocity - velocity + push) / mass
	var steering = (desired_velocity - velocity) / mass

	return velocity + steering
