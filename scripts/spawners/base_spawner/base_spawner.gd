extends Node2D
class_name Spawner

@export var mob_scenes : Array[PackedScene] = []
@export var spawn_interval : float = 2.0
@export var max_mobs : int = 20
@export var min_spawn_distance : float = 300.0
@export var max_spawn_distance : float = 600.0
@export var max_place_attempts : int = 10
@export var orb_spawner : OrbSpawner = null

var _timer : float = 0.0
var _active_mobs : Array[Node] = []
var _player : Entity = null

#=========== LIFECYCLE ================
func _ready() -> void:
	_find_player()
	on_ready()
	
func _physics_process( delta: float ) -> void:
	if not is_instance_valid( _player ):
		_find_player()
		return
		
	_active_mobs = _active_mobs.filter( func(m): return is_instance_valid(m)   )
	
	_timer += delta
	if _timer >= spawn_interval:
		_timer -= spawn_interval
		_try_spawn()
		
#=========== CORE SPAWN LOGIC ================
func _try_spawn() -> void:
	if _active_mobs.size() >= max_mobs:
		return
		
	if not can_spawn():
		return
		
	var scene = pick_scene()
	if scene == null:
		push_warning( "Spawner: pick_scene() returned null, no mob spawned.")
		return
		
	var pos = pick_spawn_position()
	if pos == Vector2.INF:
		return
		
	var mob : Node = scene.instantiate()
	get_parent().add_child( mob )
	mob.global_position = pos
	_active_mobs.append( mob )
	on_mob_spawned( mob )
	
#=========== Virtual Methods that children OVERRIDE ================
## Called at the end of _ready(). Use for child-specific setup.
func on_ready() -> void:
	pass

## Return false to temporarily block spawning (e.g. during a boss wave).
func can_spawn() -> bool:
	return not mob_scenes.is_empty()
	
## Override to change how a scene is selected — e.g. weighted pools,
## wave sequences, or deterministic patterns
func pick_scene() -> PackedScene:
	if mob_scenes.is_empty():
		return null
	return mob_scenes[ randi() % mob_scenes.size() ]
	
## Override to change spawn positioning — e.g. fixed spawn points,
## doorways, or navmesh-aware placement.
func pick_spawn_position() -> Vector2:
	for i in max_place_attempts:
		var angle : float = randf() * TAU
		var distance : float = randf_range( min_spawn_distance, max_spawn_distance )
		var candidate : Vector2 = _player.global_position + Vector2( cos(angle), sin(angle) ) * distance
		
		return candidate
	return Vector2.INF
	
## Called right after each mob is added to the scene. Use for any
## per-mob setup the child spawner needs to do.
func on_mob_spawned( mob: Node ) -> void:
	pass
	
#=========== Utilities ================
func clear_all_mobs() -> void:
	for mob in _active_mobs:
		if is_instance_valid( mob ):
			mob.queue_free()
	_active_mobs.clear()
	
func get_active_mob_count() -> int:
	return _active_mobs.size()
	
func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_player = players[0] as Entity
