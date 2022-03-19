extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func _ready():
	Global.connect("attack_finished", self, "_on_SlashEffect_attack_finished")

func enter():
	animation_state.travel("Jump_Attack")

func _on_SlashEffect_attack_finished():
	emit_signal("finished", "previous")
