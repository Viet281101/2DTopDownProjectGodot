extends Node


signal health_changed
signal health_depleted
signal status_changed

var health = 0
export(int) var max_health = 9

var status = null
const POISON_DAMAGE = 1
var poison_cycles = 0

export (NodePath) onready var poison_timer = get_node(poison_timer) as Timer

func _ready():
	health = max_health
	poison_timer.connect('timeout', self, '_on_PoisonTimer_timeout')

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
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	
	if not effect:
		return
	match effect[0]:
		Global.STATUS_POISONED:
			_change_status(Global.STATUS_POISONED)
			poison_cycles = effect[1]
#	print("%s got hit and took %s damage. Health: %s/%s" % [get_name(), amount, health, max_health])

func heal(amount):
	health += amount
	health = min(health, max_health)
	emit_signal("health_changed", health)
#	print("%s got healed by %s points. Health: %s/%s" % [get_name(), amount, health, max_health])

func _on_PoisonTimer_timeout():
	take_damage(POISON_DAMAGE)
	poison_cycles -= 1
	if poison_cycles == 0:
		_change_status(Global.STATUS_NONE)
		return
	poison_timer.start()

