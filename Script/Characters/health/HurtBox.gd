extends Area2D

#const DamageSource = preload("res://Script/Characters/health/HitBox.gd")

func _ready():
	self.connect("area_entered", self, "_on_area_entered")
	Global.connect("invincible_started", self, "_on_HurtBox_invincible_started")
	Global.connect("invincible_ended", self, "_on_HurtBox_invincible_ended")

func _on_area_entered(area):
	owner._change_state("hurt")
	if not area is HitBox:
		return
	owner.take_damage_from(area)

func set_active(value):
	$CollisionShape2D.call_deferred("set", "disabled", not value)


func _on_HurtBox_invincible_started():
	set_deferred("monitorable", false)
#	collisionShape.set_deferred("disabled", true)

func _on_HurtBox_invincible_ended():
	monitorable = true

