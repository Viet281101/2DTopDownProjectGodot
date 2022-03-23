extends Sprite

onready var animation_player: AnimationPlayer = get_node("../AnimationPlayer")


func _ready() -> void:
	animation_player.play("animation")

func _exit_tree():
	queue_free()
