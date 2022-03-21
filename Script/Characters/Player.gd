
extends Actor
class_name Player

var states_stack = []
var current_state = null

##### Player nodes:
export (NodePath) onready var player_col = get_node(player_col) as CollisionShape2D
export (NodePath) onready var body_pivot = get_node(body_pivot) as Position2D
export (NodePath) onready var body = get_node(body) as Sprite
export (NodePath) onready var dust_trail_pos = get_node(dust_trail_pos) as Position2D
export (NodePath) onready var player_shadow = get_node(player_shadow) as Sprite
export (NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export (NodePath) onready var animationTree = get_node(animationTree) as AnimationTree

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
	Global.state_active = true
	animationTree.active = true
	for state_node in state_machine.get_children():
		state_node.connect("finished", self, "_change_state")
	
	states_stack.push_front(idle_state)
	current_state = states_stack[0]
	_change_state("idle")

func get_body():
	return body

func _process(delta):
	if Global.state_active:
		current_state.update(delta)

func _physics_process(delta):
	if Global.state_active:
		current_state.physics_update(delta)
	
	Global.is_dashing = dash_state.is_dashing()
	dust_trail_pos.global_position = body_pivot.global_position + Vector2(0, 42)
	player_col.global_position = body_pivot.global_position + Vector2(0, 26)
	player_col.rotation_degrees = 90

func _input(event):
	if Global.state_active:
		current_state.handle_input(event)
	if !Global.on_ground && event.is_action_pressed("ui_idle") or event.is_action_pressed("ui_accept"):
		_change_state("idle")

func _change_state(state_name):
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["jump", "roll", "dash", "attack", "kick", "defense"]:
		states_stack.push_front(states_map[state_name])
	elif state_name == "dead":
		return
	else:
		var new_state = states_map[state_name]  
		states_stack[0] = new_state
	
	if state_name == "attack":
		$WeaponPivot/Offset/SlashEffect.attack()
	if state_name == "jump":
		jump_state.initialize(current_state.speed, current_state.velocity)
	
	current_state = states_stack[0]
	if state_name != "previous":
		# To not reinitialize the state if we"re going back to the previous state
		current_state.enter()
	Global.emit_signal("state_changed", states_stack)

func reset(target_global_position):
	.reset(target_global_position)

func take_damage_from(damage_source):
	if state_machine.current_state == hurt_state:
		return
	.take_damage_from(damage_source)
	hurt_state.knockback_direction = (damage_source.global_position - global_position).normalized()

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func _on_Die_finished(next_state_name):
	set_dead(true)
