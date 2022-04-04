extends Motion

onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer
onready var dust_trail = $DustTrail
onready var dust_burst = $DustBurst
onready var ghost_scene = preload("res://Scene/Characters/States/DashGhost.tscn")
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")
var sprite

var move_speed = 9000
var dash_speed = 50000
var dash_duration = 0.2
var dash_delay = 0.4

func _ready():
	duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")
	ghost_timer.connect("timeout", self, "_on_GhostTimer_timeout")

func enter():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	start_dash(owner.get_node("BodyPivot/Sprite"), dash_duration, input_direction)

func physics_update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var speed = dash_speed if self.is_dashing() else move_speed
	
	var velocity = input_direction.normalized() * speed * delta
	owner.move_and_slide(velocity)
	animation_state.travel("Run")
	
	dust_trail.global_position = owner.get_node("DustTrailPos").global_position + Vector2(0, -16)
	dust_burst.global_position = owner.get_node("DustTrailPos").global_position + Vector2(0, -16)
	

func instance_ghost():
	var ghost : Sprite = ghost_scene.instance()
	get_parent().get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = owner.get_node("BodyPivot/Sprite").global_position
	ghost.texture = sprite.texture
	ghost.hframes = sprite.hframes
	ghost.vframes = sprite.vframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	

func start_dash(sprite, duration, direction):
	owner.get_node("HurtBox").set_active(false)
	self.sprite = sprite
	sprite.material.set_shader_param("mix_weight", 0.7)
	sprite.material.set_shader_param("whiten", false)
	
	duration_timer.wait_time = duration
	duration_timer.start()
	ghost_timer.wait_time = 0.02
	ghost_timer.start()
	instance_ghost()
	
	dust_trail.restart()
	dust_trail.emitting = true
	
	dust_burst.rotation = (direction * -1).angle()
	dust_burst.restart()
	dust_burst.emitting = true

func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	sprite.material.set_shader_param("whiten", false)
	
	Global.can_dash = false
	yield(get_tree().create_timer(dash_delay), "timeout")
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	emit_signal("finished", "previous")
	owner.get_node("HurtBox").set_active(true)
	Global.can_dash = true

func _on_DurationTimer_timeout():
	end_dash()

func _on_GhostTimer_timeout():
	instance_ghost()
