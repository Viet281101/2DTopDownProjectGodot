
extends Monster
class_name Ghost, "res://assets/characters/monsters/ghost/ghost_icon.png"

export (NodePath) onready var tween_node = get_node(tween_node) as Tween
export (NodePath) onready var health_node = get_node(health_node) as Node
onready var state_machine = $StateMachine

var start_global_position

func _ready():
	visible = false
	set_invincible(true)
	start_global_position = global_position
	health_node.connect("health_changed", self, "_on_Health_health_changed")
	health_node.connect("health_depleted", self, "_on_Health_health_depleted")
#	start()

func start():
	state_machine.start()

func _on_Health_health_depleted():
	set_invincible(true)

func set_invincible(value):
	$CollisionShape2D.disabled = value
	$HitBox/CollisionShape2D.disabled = value
	$DamageSource/CollisionPolygon2D.disabled = value
	$DamageSource/CollisionShape2D.disabled = value
	$DamageSource.monitorable = not value

func _on_Health_health_changed(new_health):
	tween_node.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_node.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween_node.start()
	match state_machine.phase:
		1:
			if new_health < 100:
				state_machine.phase = 2
		2:
			if new_health < 50:
				state_machine.phase = 3

func take_damage_from(attacker):
	health_node.take_damage(attacker.damage)

func _on_target_died():
	._on_target_died()
	state_machine.change_phase(4)
	state_machine.go_to_next_state()
