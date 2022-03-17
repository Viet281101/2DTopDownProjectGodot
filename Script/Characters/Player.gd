
extends KinematicBody2D
class_name Player

signal state_changed
signal direction_changed(new_direction)

var look_direction = Vector2(1, 0) setget set_look_direction

var states_stack = []
var current_state = null

##### Player nodes:
export (NodePath) onready var player_col = get_node(player_col) as CollisionShape2D
export (NodePath) onready var body_pivot = get_node(body_pivot) as Position2D
export (NodePath) onready var dust_trail_pos = get_node(dust_trail_pos) as Position2D
export (NodePath) onready var player_shadow = get_node(player_shadow) as Sprite
export (NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export (NodePath) onready var animationTree = get_node(animationTree) as AnimationTree
export (NodePath) onready var health = get_node(health) as Node

### State Machine Node:
export (NodePath) onready var state_machine = get_node(state_machine) as Node
export (NodePath) onready var idle_state = get_node(idle_state) as Node
export (NodePath) onready var walk_state = get_node(walk_state) as Node
export (NodePath) onready var run_state = get_node(run_state) as Node
export (NodePath) onready var jump_state = get_node(jump_state) as Node
export (NodePath) onready var roll_state = get_node(roll_state) as Node
export (NodePath) onready var dash_state = get_node(dash_state) as Node
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
	"dash": dash_state,
	"attack": attack_state,
	"kick": kick_state,
	"defense": defense_state,
	"hurt": hurt_state,
	"dead": die_state,
}

func _ready():
	animationTree.active = true
	for state_node in state_machine.get_children():
		state_node.connect("finished", self, "_change_state")
	
	states_stack.push_front(idle_state)
	current_state = states_stack[0]
	_change_state("idle")

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)
	
	Global.is_dashing = dash_state.is_dashing()
	dust_trail_pos.global_position = body_pivot.global_position + Vector2(0, 42)
	player_col.global_position = body_pivot.global_position + Vector2(0, 20)

func _input(event):
	current_state.handle_input(event)

func _change_state(state_name):
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["jump", "roll", "dash", "attack", "kick", "defense"]:
		states_stack.push_front(states_map[state_name])
	elif state_name == "dead":
		queue_free()
		return
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state
	
	if state_name == "attack":
		pass
	if state_name == "jump":
		jump_state.initialize(current_state.speed, current_state.velocity)
	
	current_state = states_stack[0]
	if state_name != "previous":
		# To not reinitialize the state if we"re going back to the previous state
		current_state.enter()
	emit_signal("state_changed", states_stack)

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	player_col.disabled = value

func set_look_direction(value):
	look_direction = value
	emit_signal("direction_changed", value)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func take_damage(attacker, amount, effect=null):
	if self.is_a_parent_of(attacker):
		return
	hurt_state.knockback_direction = (attacker.global_position - global_position).normalized()
	health.take_damage(amount, effect)

