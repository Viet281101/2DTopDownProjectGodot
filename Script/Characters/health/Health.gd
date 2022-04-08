
extends Node
class_name Health, "res://assets/gui/heart-ui-nva.png"

signal health_changed(new_health)
signal damage_taken(new_health)
signal health_depleted()
signal status_changed

var modifiers = {}

export(int) var max_health = 9 setget set_max_health
export(int) var strength = 2
export(int) var defense = 0

var status = null
const POISON_DAMAGE = 1
var poison_cycles = 0

export (NodePath) onready var poison_timer = get_node(poison_timer) as Timer
onready var timer = $Timer

var invincible = false setget set_invincible

func set_invincible(value):
	invincible = value
	if invincible == true:
		Global.emit_signal("invincible_started")
	else:
		Global.emit_signal("invincible_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false

func _ready():
	Global.health = max_health
	poison_timer.connect('timeout', self, '_on_PoisonTimer_timeout')

func set_max_health(value):
	max_health = max(0, value)

func _change_status(new_status):
	match status:
		Global.STATUS_POISONED:
			poison_timer.stop()
	
	match new_status:
		Global.STATUS_POISONED:
			poison_cycles = 0
			poison_timer.start()
	status = new_status
	emit_signal('status_changed', new_status)

func take_damage(amount, effect=null):
	if status == Global.STATUS_INVINCIBLE:
		return
	Global.health -= amount
	Global.health = max(0, Global.health)
	emit_signal("health_changed", Global.health)
	emit_signal("damage_taken", Global.health)
	
	if not effect:
		return
	match effect[0]:
		Global.STATUS_POISONED:
			_change_status(Global.STATUS_POISONED)
			poison_cycles = effect[1]
#	print("%s got hit and took %s damage. Global.health: %s/%s" % [get_name(), amount, Global.health, max_Global.health])

	if Global.health == 0:
		emit_signal("health_depleted")

func heal(amount):
	Global.health += amount
	Global.health = min(Global.health, max_health)
	emit_signal("health_changed", Global.health)
#	print("%s got healed by %s points. Global.health: %s/%s" % [get_name(), amount, Global.health, max_Global.health])

func add_modifier(id, modifier):
	modifiers[id] = modifier

func remove_modifier(id):
	modifiers.erase(id)

func _on_PoisonTimer_timeout():
	take_damage(POISON_DAMAGE)
	poison_cycles -= 1
	if poison_cycles == 0:
		_change_status(Global.STATUS_NONE)
		return
	poison_timer.start()

