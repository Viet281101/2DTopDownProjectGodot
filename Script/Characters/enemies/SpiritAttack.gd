
extends State

var explosion_scene = preload("res://Scene/Effects/Dust.tscn")
var explosion_count = 0
var direction = Vector2()

func _ready():
	$ExplodeTimer.connect("timeout", self, "_on_ExplodeTimer_timeout")

func enter():
	explosion_count = 0
	owner.get_node('AnimationPlayer').play('shriek')

func _on_animation_finished(anim_name):
	$ExplodeTimer.stop()
	emit_signal('finished')

func stomp():
	direction = (owner.target.position - owner.global_position).normalized()
	$ExplodeTimer.start()
	explode()

func _on_ExplodeTimer_timeout():
	explode()

func explode():
	explosion_count += 1

	var new_explosion = explosion_scene.instance()
	new_explosion.position = owner.position + explosion_count * direction * 80.0
	self.add_child(new_explosion)
	

