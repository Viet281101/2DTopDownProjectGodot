extends State

export(float) var SPEED = 60.0
var direction = Vector2(-1.0, 0.0)

func enter():
	owner.get_node('AnimationPlayer').play('shriek')
	owner.get_node('Pivot/Body').scale = Vector2(1.0, 1.0)

func update(delta):
	owner.move_and_slide(direction * SPEED)

func _on_animation_finished(anim_name):
	owner.get_node('AnimationPlayer').play('shriek')
	emit_signal('finished')
