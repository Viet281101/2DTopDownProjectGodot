extends Camera2D

export (NodePath) onready var topLeft = get_node(topLeft) as Position2D
export (NodePath) onready var bottomRight = get_node(bottomRight) as Position2D
export (NodePath) onready var light = get_node(light) as Light2D
export (NodePath) onready var timer = get_node(timer) as Timer
export (NodePath) onready var tween = get_node(tween) as Tween

var shake_amount = 0
var default_offset = offset

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	
	set_process(false)
	Global.camera = self
	randomize()

func _process(_delta):
	offset = Vector2(rand_range(-1, 1) * shake_amount, rand_range(-1, 1) * shake_amount)

func shake(time, amount):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_Timer_timeout():
	set_process(false)
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, 6, 2)
	tween.start()
