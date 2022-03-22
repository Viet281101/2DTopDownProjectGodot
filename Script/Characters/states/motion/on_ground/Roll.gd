extends OnGround

onready var duration_timer = $DurationTimer
onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

var move_speed = 8000
var roll_speed = 18000
var roll_duration = 0.5
var roll_delay = 0.2

func _ready():
	duration_timer.connect("timeout", self, "_on_DurationTimer_timeout")

func enter():
	start_roll(roll_duration)

func physics_update(delta):
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	var speed = roll_speed if self.is_rolling() else move_speed
	
	var velocity = input_direction.normalized() * speed * delta
	owner.move_and_slide(velocity)
	animation_state.travel("Roll")

func start_roll(duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	owner.get_node("HitBox").set_active(false)

func is_rolling():
	return !duration_timer.is_stopped()

func end_roll():
	Global.can_roll = false
	yield(get_tree().create_timer(roll_delay), "timeout")
	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	if not input_direction:
		animation_state.travel("Idle")
	if input_direction:
		animation_state.travel("Walk")
	emit_signal("finished", "previous")
	owner.get_node("HitBox").set_active(true)
	Global.can_roll = true

func _on_DurationTimer_timeout():
	end_roll()
