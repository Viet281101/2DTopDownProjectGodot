
extends OnGround

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	animation_state.travel("Idle")
	Global.on_ground = true

func handle_input(event):
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("finished", "walk")
