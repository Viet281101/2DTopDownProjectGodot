
class_name OnGround
extends Motion


var speed = 0.0
var velocity = Vector2()

func handle_input(event):
	if event.is_action_pressed("ui_jump"):
		emit_signal("finished", "jump")
	if event.is_action_pressed("ui_roll"):
		emit_signal("finished", "roll")
	return .handle_input(event)

