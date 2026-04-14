extends SkillShot
class_name RocketPunch

func _ready() -> void:
	projectile_scene = preload("res://scenes/abilities/rocket_punch/rocket_punch_projectile.tscn")
	
	mana_cost = 3
	damage = 30
	cooldown = 0
	
	projectile_speed = 200.0
	projectile_range = 200.0
	await super._ready()
