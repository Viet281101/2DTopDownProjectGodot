extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	animation_state.travel("Attack_A")

func _on_SlashEffect_attack_finished():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	
	emit_signal("finished", "previous")
