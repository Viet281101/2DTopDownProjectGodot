extends Position2D

var z_index_start = 0

func _ready() -> void:
	Global.connect("direction_changed", self, '_on_Parent_direction_changed')
	z_index_start = z_index

func _on_Parent_direction_changed(direction : Vector2) -> void:
	rotation = direction.angle()
	match direction:
		Vector2(0, -1):
			z_index = z_index_start + 1
		Vector2(1, -1):
			z_index = z_index_start + 1
		Vector2(-1, -1):
			z_index = z_index_start + 1
		Vector2(-1, 1):
			z_index = z_index_start + 2
		Vector2(1, 1):
			z_index = z_index_start + 2
		Vector2(0, 1):
			z_index = z_index_start + 2
		_:
			z_index = z_index_start

