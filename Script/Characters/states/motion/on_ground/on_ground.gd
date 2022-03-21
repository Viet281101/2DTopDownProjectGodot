
class_name OnGround
extends Motion


var speed = 0.0
var velocity = Vector2()

func enter():
	Global.on_ground = true

func handle_input(event):
	if event.is_action_pressed("ui_attack") && Global.can_attack:
		emit_signal("finished", "attack")
	if event.is_action_pressed("ui_jump"):
		emit_signal("finished", "jump")
		Global.on_ground = false
	if event.is_action_pressed("ui_roll") && Global.can_roll && !Global.is_rolling:
		emit_signal("finished", "roll")
	return .handle_input(event)

