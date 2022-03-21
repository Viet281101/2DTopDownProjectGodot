extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")
onready var touch_ground_dust = preload("res://Scene/Effects/TouchGroundDust.tscn")

func _ready():
	Global.connect("attack_finished", self, "_on_SlashEffect_attack_finished")

func enter():
	if Global.on_ground:
		attack(Global.sword_count)
	if !Global.on_ground:
		animation_state.travel("Jump_Attack")
		Global.jump_attacked = true
		Global.state_cooldown(1)
	Global.can_attack = false

func _on_SlashEffect_attack_finished():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	
	emit_signal("finished", "previous")
	
	if Global.jump_attacked:
		yield(get_tree().create_timer(0.8), "timeout")
		Global.can_attack = true
		Global.jump_attacked = false
	else:
		Global.can_attack = true
		Global.jump_attacked = false

func attack(type):
	type = Global.combo[Global.sword_count - 1]
	animation_state.travel(type['animation'])
	slash_dust()

func slash_dust():
	var slash_dust = 1
	yield(get_tree().create_timer(0.2), "timeout")
	var dust = touch_ground_dust.instance()
	get_parent().get_parent().get_parent().add_child(dust)
	dust.animate(slash_dust)
	dust.global_position = owner.get_node("DustTrailPos").global_position + Vector2(0, -17)

