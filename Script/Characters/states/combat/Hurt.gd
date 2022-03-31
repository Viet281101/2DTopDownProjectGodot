extends State

var knockback_direction = Vector2()
onready var duration_timer = $DurationTimer
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func _ready():
	duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

func enter():
	animation_state.travel("Hurt_1")
	duration_timer.start()

func _on_DurationTimer_timeout():
	owner.get_body().modulate = Color('#ffffff')
	emit_signal("finished", "idle")
