extends Motion

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")
onready var touch_ground_dust = preload("res://Scene/Effects/TouchGroundDust.tscn")
var combo = [{
		'damage': 1,
		'animation': 'Attack_A',
		'effect': null
	},
	{
		'damage': 1,
		'animation': 'Attack_B',
		'effect': null
	},
	{
		'damage': 3,
		'animation': 'Attack_C',
		'effect': null
	},
	{
		'damage': 4,
		'animation': 'Attack_D',
		'effect': null
	},]

func _ready():
	Global.connect("attack_finished", self, "_on_SlashEffect_attack_finished")

func enter():
	var type_dust = 1
	if Global.on_ground:
		attack(Global.sword_count)
	if !Global.on_ground:
		animation_state.travel("Jump_Attack")
		Global.state_cooldown(1.5)
	yield(get_tree().create_timer(0.2), "timeout")
	var dust = touch_ground_dust.instance()
	get_parent().get_parent().get_parent().add_child(dust)
	dust.animate(type_dust)
	dust.global_position = owner.get_node("DustTrailPos").global_position + Vector2(0, -17)

func _on_SlashEffect_attack_finished():
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	
	emit_signal("finished", "previous")

func attack(type):
	type = combo[Global.sword_count - 1]
	animation_state.travel(type['animation'])
