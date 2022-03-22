
extends DamageSource

enum STATES { IDLE, ATTACK }
var state = null

enum ATTACK_INPUT_STATES { IDLE, LISTENING, REGISTERED }
var attack_input_state = ATTACK_INPUT_STATES.IDLE
var ready_for_next_attack = false
const MAX_COMBO_COUNT = 3
var attack_current = {}

var hit_objects = []

onready var animate = $AnimationPlayer

func _ready():
	animate.connect('animation_finished', self, "_on_animation_finished")
#	self.connect("body_entered", self, "_on_body_entered")
	_change_state(STATES.IDLE)

func _change_state(new_state):
	match state:
		STATES.ATTACK:
			hit_objects = []
			attack_input_state = ATTACK_INPUT_STATES.IDLE
			ready_for_next_attack = false

	match new_state:
		STATES.IDLE:
			animate.stop()
			visible = false
			monitoring = false
		STATES.ATTACK:
#			var attack = Global.combo[min(Global.sword_count, Global.combo.size() - 1)]
			attack_current = Global.combo[Global.sword_count - 1]
			if !Global.on_ground:
				animate.play("Jump_Attack")
			else:
				animate.play(attack_current['animation'])
			damage = attack_current['damage']
			effect = attack_current["effect"]
			visible = true
			monitoring = true
	state = new_state

func _input(event):
	if not state == STATES.ATTACK:
		return
	if attack_input_state != ATTACK_INPUT_STATES.LISTENING:
		return
	if event.is_action_pressed('ui_attack'):
		attack_input_state = ATTACK_INPUT_STATES.REGISTERED

func _physics_process(delta):
	if attack_input_state == ATTACK_INPUT_STATES.REGISTERED and ready_for_next_attack:
		attack()

func attack():
	Global.sword_count += 1
	Global.sword_time.start(Global.sword_time_count)
	yield(get_tree().create_timer(0.5), "timeout")
	_change_state(STATES.ATTACK)
	

## use with AnimationPlayer func track
func set_attack_input_listening():
	attack_input_state = ATTACK_INPUT_STATES.LISTENING

## use with AnimationPlayer func track
func set_ready_for_next_attack():
	ready_for_next_attack = true

func _on_body_entered(body):
	if not body.has_node('Health'):
		return
	if body.get_rid().get_id() in hit_objects:
		return
	hit_objects.append(body.get_rid().get_id())
	body.take_damage(self, attack_current['damage'], attack_current['effect'])

func _on_animation_finished(name):
	if not attack_current:
		return

	if attack_input_state == ATTACK_INPUT_STATES.REGISTERED and Global.sword_count < MAX_COMBO_COUNT:
		attack()
	else:
		_change_state(STATES.IDLE)
		Global.emit_signal("attack_finished")

func _on_StateMachine_state_changed(current_state):
	if current_state.name == "attack":
		attack()
