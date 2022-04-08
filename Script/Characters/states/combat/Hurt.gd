extends State

var knockback_direction = Vector2()
onready var duration_timer = $DurationTimer
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")
var hurt_lst = {
	1 : "Hurt_1",
	2 : "Hurt_2",
}

func _ready():
	duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

func enter():
	Global.hurt_count += 1
	animation_state.travel(hurt_lst[Global.hurt_count])
	duration_timer.start()

func _on_DurationTimer_timeout():
	owner.get_body().modulate = Color('#ffffff')
	emit_signal("finished", "idle")
