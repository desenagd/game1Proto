extends PointAndClick
class_name LightPunch

var _hit_effect_scene = preload("res://scenes/abilities/light_punch/light_punch_hit_effect.tscn")

func _ready() -> void:
	await super._ready()
	mana_cost = 1
	cooldown = 0.5
	
func _on_hit( target ) -> void:
	var effect = _hit_effect_scene.instantiate()
	target.add_child(effect)
	effect.position = Vector2.ZERO
	
	
