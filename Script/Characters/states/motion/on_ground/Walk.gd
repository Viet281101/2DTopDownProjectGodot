extends OnGround

export(float) var MAX_WALK_SPEED = 150

onready var animation_state = owner.get_node("AnimationTree").get("parameters/playback")

func enter():
	speed = 0.0
	velocity = Vector2()

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	
	animation_state.travel("Walk")

func handle_input(event):
	return .handle_input(event)

func physics_update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)

	speed = MAX_WALK_SPEED + Global.warrior_speed
	var collision_info = move(speed, input_direction)
	if not collision_info:
		return
	if speed == MAX_WALK_SPEED and collision_info.collider.is_in_group("environment"):
		return null

func move(speed, direction):
	velocity = direction.normalized() * speed
	owner.move_and_slide(velocity, Vector2(), 5, 2)
	if owner.get_slide_count() == 0:
		return
	return owner.get_slide_collision(0)
