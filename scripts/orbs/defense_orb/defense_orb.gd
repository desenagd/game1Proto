extends Orb
class_name DefenseOrb

func _ready() -> void:
	stat_bonus = 5
	despawn_time = 60
	spawn_weight = 1.0
	super._ready()

func _apply_bonus( player: Entity ) -> void:
	player.armor += stat_bonus
