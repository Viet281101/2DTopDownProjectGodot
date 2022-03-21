
class_name OnGround
extends Motion


var speed = 0.0
var velocity = Vector2()

func enter():
	Global.on_ground = true

func handle_input(event):
	if event.is_action_pressed("ui_attack"):
		emit_signal("finished", "attack")
		yield(get_tree().create_timer(Global.attack_cooldown), "timeout")
	if event.is_action_pressed("ui_jump"):
		emit_signal("finished", "jump")
		Global.on_ground = false
	if event.is_action_pressed("ui_roll"):
		emit_signal("finished", "roll")
	return .handle_input(event)

