extends Spawner
class_name SlimeSpawner

#@export var spawn_path : Path2D = null
var _path_follow : PathFollow2D = null
#@onready var _path_follow : PathFollow2D = null

func on_ready() -> void:
	pass
	#_path_follow = get_node( "Path2D/PathFollow2D")
	#if _path_follow == null:
		#push_warning( "Slime spawner: spawn_path is not assigned")
		#return
	#_path_follow = spawn_path.get_node( "PathFollow2D" )
	#spawn_interval = 0.5
	#max_mobs = 15
	#min_spawn_distance = 250
	#max_spawn_distance = 750
	
func set_spawn_path( path : Path2D ) -> void:
	_path_follow = path.get_node( "PathFollow2D" )
	if _path_follow == null:
		push_warning("SlimeSpawner: PathFollow2D not found on given path")

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

func _apply_difficulty( difficulty : Mission.MissionRank ) -> void:
	match difficulty:
		Mission.MissionRank.EF1:
			mob_min = 5;   mob_max = 15
			interval_min = 1.5; interval_max = 3.0
		Mission.MissionRank.EF2:
			mob_min = 15;  mob_max = 30
			interval_min = 1.0; interval_max = 2.5
		Mission.MissionRank.EF3:
			mob_min = 30;  mob_max = 50
			interval_min = 0.8; interval_max = 2.0
		Mission.MissionRank.EF4:
			mob_min = 50;  mob_max = 65
			interval_min = 0.5; interval_max = 1.5
		Mission.MissionRank.EF5:
			mob_min = 65;  mob_max = 80
			interval_min = 0.1; interval_max = 1.0
