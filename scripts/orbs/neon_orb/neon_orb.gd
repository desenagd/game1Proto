extends Orb
class_name NeonOrb

func _ready() -> void:
	stat_bonus = 3
	despawn_time = 180.0
	spawn_weight = 0.25
	super._ready()
	
func _apply_bonus( player : Entity ) -> void:
	player.current_health = min(player.current_health + stat_bonus, player.max_health)
	player.max_health += stat_bonus
	player.health_regen += stat_bonus
	
	player.armor += stat_bonus
	
	player.current_mana = min(player.current_mana + stat_bonus, player.max_mana)
	player.max_mana += stat_bonus
	player.mana_regen += stat_bonus
	
	player.current_speed += stat_bonus
	
	
	
