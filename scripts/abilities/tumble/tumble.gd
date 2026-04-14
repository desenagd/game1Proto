extends Dash
class_name Tumble

func _ready() -> void:
	await super._ready()
	
	mana_cost = 15
	dash_distance = 125.0
	dash_speed = 1250.0
	cooldown = 0
