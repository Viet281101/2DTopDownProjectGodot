extends State

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

### Initialize the state. E.g. change the animation
func enter():
	owner.set_dead(true)
	animation_state.travel("Die")

func _on_animation_finished(anim_name):
	emit_signal("finished", "dead")

