
class_name Motion
extends State

onready var animation_tree = owner.get_node("AnimationTree")

func handle_input(event):
	if event.is_action_pressed("ui_attack") && !Global.on_ground:
		emit_signal("finished", "attack")
	if event.is_action_pressed("ui_dash") && Global.can_dash && !Global.is_dashing:
		emit_signal("finished", "dash")

func get_input_direction():
	var input_vector = Vector2()
	input_vector.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	input_vector.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))
	return input_vector
	

func update_look_direction(input_vector):
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Jump/blend_position", input_vector)
		animation_tree.set("parameters/Jump_Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_tree.set("parameters/Dash/blend_position", input_vector)
		animation_tree.set("parameters/Attack_A/blend_position", input_vector)
		animation_tree.set("parameters/Attack_B/blend_position", input_vector)
		animation_tree.set("parameters/Attack_C/blend_position", input_vector)
		animation_tree.set("parameters/Attack_D/blend_position", input_vector)
		animation_tree.set("parameters/Defense/blend_position", input_vector)
		animation_tree.set("parameters/Kick/blend_position", input_vector)
		animation_tree.set("parameters/Hurt/blend_position", input_vector)
		animation_tree.set("parameters/Die/blend_position", input_vector)
		owner.look_direction = input_vector
	return input_vector

