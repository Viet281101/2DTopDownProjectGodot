extends Motion


func _ready():
	$ShieldPivot.hide()
	Global.connect("direction_changed", self, '_on_Parent_direction_changed')

func _physics_process(delta):
	$ShieldPivot.global_position = owner.global_position

func _on_Parent_direction_changed(direction):
	$ShieldPivot.rotation = direction.angle()
