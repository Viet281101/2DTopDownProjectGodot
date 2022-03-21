extends State

var knockback_direction = Vector2()
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	animation_state.travel("Hurt_1")

func _on_animation_finished(anim_name):
	owner.get_body().modulate = Color('#ffffff')
	emit_signal("finished", "previous")
