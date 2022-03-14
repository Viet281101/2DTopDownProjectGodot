
class_name Motion
extends State

onready var animation_tree = owner.get_node("AnimationTree")

func handle_input(event):
	if event.is_action_pressed("ui_attack"):
		emit_signal("finished", "attack")

func get_input_direction():
	var input_vector = Vector2()
	input_vector.x = int(Input.get_action_strength("ui_right")) - int(Input.get_action_strength("ui_left"))
	input_vector.y = int(Input.get_action_strength("ui_down")) - int(Input.get_action_strength("ui_up"))
	return input_vector
	

func update_look_direction(input_vector):
#	if direction and owner.look_direction != direction:
#		owner.look_direction = direction
#	if not direction.x in [-1, 1]:
#		return
#	owner.get_node("BodyPivot").set_scale(Vector2(direction.x, 1))
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Walk/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Jump/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
