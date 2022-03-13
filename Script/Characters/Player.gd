extends KinematicBody2D
class_name Player

signal state_changed
signal direction_changed(new_direction)

var look_direction = Vector2(1, 0) setget set_look_direction

var states_stack = []
var current_state = null

export (NodePath) onready var idle_state = get_node(idle_state) as Node
export (NodePath) onready var walk_state = get_node(walk_state) as Node
export (NodePath) onready var run_state = get_node(run_state) as Node
export (NodePath) onready var jump_state = get_node(jump_state) as Node
export (NodePath) onready var roll_state = get_node(roll_state) as Node
export (NodePath) onready var attack_state = get_node(attack_state) as Node
export (NodePath) onready var kick_state = get_node(kick_state) as Node
export (NodePath) onready var defense_state = get_node(defense_state) as Node
export (NodePath) onready var hurt_state = get_node(hurt_state) as Node
export (NodePath) onready var die_state = get_node(die_state) as Node

onready var states_map = {
	"idle": idle_state,
	"walk": walk_state,
	"run": run_state,
	"jump": jump_state,
	"roll": roll_state,
	"attack": attack_state,
	"kick": kick_state,
	"defense": defense_state,
	"hurt": hurt_state,
	"death": die_state,
}


func _ready():
	pass



func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)
