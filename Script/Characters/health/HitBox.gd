extends Area2D

#const DamageSource = preload("res://Script/Characters/health/DamageSource.gd")

func _ready():
	self.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area):
	if not area is DamageSource:
		return
	owner.take_damage_from(area)

func set_active(value):
	$CollisionShape2D.call_deferred("set", "disabled", not value)

