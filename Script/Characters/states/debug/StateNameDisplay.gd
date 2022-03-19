extends Label


var start_position = Vector2()

func _ready():
	Global.connect("state_changed", self, "_on_Player_state_changed")
	start_position = rect_position

func _physics_process(delta):
	rect_position = $"../BodyPivot".position + start_position

func _on_Player_state_changed(states_stack):
	text = states_stack[0].get_name()
