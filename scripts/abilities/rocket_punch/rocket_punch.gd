extends SkillShot
class_name RocketPunch

func _ready() -> void:
	projectile_scene = preload("res://scenes/abilities/rocket_punch/rocket_punch_projectile.tscn")
	
	damage = 30
	projectile_speed = 200.0
	projectile_range = 200.0
	await super._ready()
