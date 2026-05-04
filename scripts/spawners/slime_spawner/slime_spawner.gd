extends Spawner
class_name SlimeSpawner

#@export var spawn_path : Path2D = null
var _path_follow : PathFollow2D = null
#@onready var _path_follow : PathFollow2D = null

func _randomize_stats() -> void:
	mob_min = 5
	mob_max = 75
	
	interval_min = 0.1
	interval_max = 2.0
	
	min_dist_min = 250.0
	min_dist_max = 500.0
	super._randomize_stats()

func on_ready() -> void:
	_path_follow = get_node( "Path2D/PathFollow2D")
	if _path_follow == null:
		push_warning( "Slime spawner: spawn_path is not assigned")
		return
	#_path_follow = spawn_path.get_node( "PathFollow2D" )
	#spawn_interval = 0.5
	#max_mobs = 15
	#min_spawn_distance = 250
	#max_spawn_distance = 750

func on_mob_spawned( mob: Node ) -> void:
	if orb_spawner != null:
		orb_spawner.connect_mob( mob as Entity)
	else:
		push_warning("SlimeSpawner: orb_spawner is not assigned!")

func pick_spawn_position() -> Vector2:
	if _path_follow == null:
		push_warning( "SlimeSpawner: no spawn_path assigned bruh")
		return Vector2.INF
	_path_follow.progress_ratio = randf()
	return _path_follow.global_position
