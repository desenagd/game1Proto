extends Spawner
class_name SlimeSpawner

func on_ready() -> void:
	spawn_interval = 2.0
	max_mobs = 15
	min_spawn_distance = 250
	max_spawn_distance = 750

func on_mob_spawned( mob: Node ) -> void:
	if orb_spawner != null:
		orb_spawner.connect_mob( mob as Entity)
	else:
		push_warning("SlimeSpawner: orb_spawner is not assigned!")
