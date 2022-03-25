extends State


func enter():
	owner.set_invincible(true)
	owner.get_node('AnimationPlayer').play('apear')

func exit():
	owner.set_invincible(false)

func _on_animation_finished(anim_name):
	assert(anim_name == 'apear')
	emit_signal('finished')
	
