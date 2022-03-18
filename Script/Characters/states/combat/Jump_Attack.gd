extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	animation_state.travel("Jump_Attack")
