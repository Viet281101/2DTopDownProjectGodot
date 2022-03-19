extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")
onready var touch_ground_dust = preload("res://Scene/Effects/TouchGroundDust.tscn")

func enter():
	animation_state.travel("Attack_A")
	yield(get_tree().create_timer(0.2), "timeout")
	var dust = touch_ground_dust.instance()
	get_parent().get_parent().get_parent().add_child(dust)
	dust.animate(1)
	dust.global_position = owner.get_node("DustTrailPos").global_position + Vector2(0, -17)

func _on_SlashEffect_attack_finished():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	
	emit_signal("finished", "previous")
