extends State

var knockback_direction = Vector2()
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	animation_state.travel("Idle")
