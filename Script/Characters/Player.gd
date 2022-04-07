
extends Actor
class_name Warrior, "res://assets/characters/warrior/helmet_ego.png"

const DUST_SCENE: PackedScene = preload("res://Scene/Effects/Dust.tscn")
onready var parent: Node = get_parent()

var states_stack = []
var current_state = null

##### Player nodes:
export (NodePath) onready var player_col = get_node(player_col) as CollisionShape2D
export (NodePath) onready var hurtbox = get_node(hurtbox) as CollisionShape2D
export (NodePath) onready var body_pivot = get_node(body_pivot) as Position2D
export (NodePath) onready var body = get_node(body) as Sprite
export (NodePath) onready var body_weapon = get_node(body_weapon) as Sprite
export (NodePath) onready var dust_trail_pos = get_node(dust_trail_pos) as Position2D
export (NodePath) onready var player_shadow = get_node(player_shadow) as Sprite
export (NodePath) onready var sword = get_node(sword) as Area2D
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
	Global.player = self
	animationTree.active = true
	animationPlayer.connect("animation_finished", self, "_on_animation_finished")
#	no_sword_in_hand()
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
	body_nodes_pos()
	if Global.state_active:
		current_state.physics_update(delta)

func _input(event):
	if Global.state_active:
		current_state.handle_input(event)

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
		### To not reinitialize the state if we"re going back to the previous state
		current_state.enter()
	Global.emit_signal("state_changed", states_stack)

func reset(target_global_position):
	.reset(target_global_position)

func take_damage_from(damage_source):
	.take_damage_from(damage_source)
	hurt_state.knockback_direction = (damage_source.global_position - global_position).normalized()
	health.start_invincibility(0.4)
	Global.camera.shake(1, 0.4)

func spawn_dust() -> void:
	var dust: Node2D = DUST_SCENE.instance()
	dust.position = dust_trail_pos.global_position + Vector2(0, -20)
	dust.rotation = look_direction.angle()
	if look_direction.x == -1:
		dust.get_node("Dust").flip_v = true
	else:
		dust.get_node("Dust").flip_v = false
	parent.add_child_below_node(parent.get_child(get_index() - 1), dust)

func no_sword_in_hand():
	sword.monitoring = false
	sword.visible = false
	body_weapon.visible = false
	Global.can_attack = false
	body.visible = true

func has_sword_in_hand():
	sword.monitoring = true
	sword.visible = true
	body_weapon.visible = true
	Global.can_attack = true
	body.visible = false

func body_nodes_pos():
	Global.is_dashing = dash_state.is_dashing()
	Global.is_rolling = roll_state.is_rolling()
	dust_trail_pos.global_position = body_pivot.global_position + Vector2(0, 42)
	player_col.global_position = body_pivot.global_position + Vector2(0, 26)
	hurtbox.global_position = body_pivot.global_position + Vector2(0, 6)
	player_col.rotation_degrees = 90

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

func _on_Die_finished(next_state_name):
	set_dead(true)
