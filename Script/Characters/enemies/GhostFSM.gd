
extends StateMachine

signal phase_changed(number)

var sequence_cycles = 0
export(int, 1, 3) var phase = 1


func _ready():
	for child in get_children():
		child.connect("finished", self, "go_to_next_state")

func initialize():
	change_phase(phase)

func _on_active_state_finished():
	go_to_next_state()

func go_to_next_state(state_override=null):
	if not active:
		return
	current_state.exit()
	current_state = _decide_on_next_state() if state_override == null else state_override
	emit_signal("state_changed", current_state)
	current_state.enter()

func start():
	.start()

func _decide_on_next_state():
	# Battle start
	if current_state == null:
		return $Apear
	if current_state == $Apear:
		return $NormalSequence

	if phase == 1:
		if current_state == $NormalSequence:
			sequence_cycles += 1
			if sequence_cycles < 2:
				return $NormalSequence
			else:
				sequence_cycles = 0
				return $SpiritAttack
		if current_state == $SpiritAttack:
			return $NormalSequence
			

func change_phase(new_phase):
	phase = new_phase
	var anim_player = owner.get_node('AnimationPlayer')
	match new_phase:
		1:
			anim_player.playback_speed = 0.8
		2:
			anim_player.playback_speed = 1.0
		3:
			anim_player.playback_speed = 1.2
		4:
			anim_player.playback_speed = 0.8
	emit_signal("phase_changed", new_phase)
	

