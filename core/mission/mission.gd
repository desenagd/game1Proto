extends Node

@export var slime_spawner_scene : PackedScene

enum MissionState {
	LOADING,
	NORMAL,
	OVERTIME,
	BOSS,
	EXTRACTION,
	COMPLETE,
}

enum MissionMaps {
	NONE,
	TEST
}

const MAPS: Dictionary = {
	MissionMaps.TEST : "res://core/MAPS/Map0/Map0.tscn",
	#add map scenes here
}

enum MissionRank {
	NONE,
	EF1,
	EF2,
	EF3,
	EF4,
	EF5
}

const RANDOM: String = "random"

const DIFFICULTY_SETTINGS: Dictionary = {
	MissionRank.EF1 : { "timer" : 120.0},
	MissionRank.EF2 : { "timer" : 180.0},
	MissionRank.EF3 : { "timer" : 240.0},
	MissionRank.EF4 : { "timer" : 300.0},
	MissionRank.EF5 : { "timer" : 360.0},
}

var current_state : MissionState = MissionState.LOADING
var current_difficulty : MissionRank = MissionRank.NONE
var current_map : Node = null
var mission_timer : float = 0.0
var is_overtime : bool = false

func _ready() -> void:
	pass

# Pass random string if random difficulty or map
# TODO: Possibly edit this to take a specific value instead of bools for mana and damage
func instantiate_mission(difficulty_key, map_key, infinite_mana: bool, no_damage: bool) -> void:
	if difficulty_key is not MissionRank:
		_randomize_mission()
	else:
		_load_mission(difficulty_key)
	
	if map_key is not MissionMaps:
		_load_random_map()
	else:
		_load_map(map_key)
	_setup_spawners()
	_spawn_player(infinite_mana, no_damage)
	current_state = MissionState.NORMAL
	await get_tree().process_frame
	_notify_spawners()

func _randomize_mission() -> void:
	# Pick random difficulty
	current_difficulty = DIFFICULTY_SETTINGS.keys()[ randi() % DIFFICULTY_SETTINGS.size() ]
	print( "Mission Difficulty: ", current_difficulty)
	
func _load_mission(difficulty_key: MissionRank) -> void:
	current_difficulty = difficulty_key

func _load_map(map_key: MissionMaps) -> void:
	var map_scene = load(MAPS[map_key])
	current_map = map_scene.instantiate()
	add_child(current_map)

func _notify_spawners() -> void:
	for spawner in get_tree().get_nodes_in_group("mob_spawners"):
		spawner.set_difficulty( current_difficulty )

func _load_random_map() -> void:
	var map_path = MAPS.values()[ randi() % MAPS.size() ]
	var map_scene = load( map_path )
	current_map = map_scene.instantiate()
	add_child( current_map )
	
func _setup_spawners() -> void:
	var spawn_path = get_tree().get_first_node_in_group("mob_spawn_paths")
	if spawn_path == null:
		push_error("No mob_spawn_paths found in map")
		return
	var spawner = slime_spawner_scene.instantiate()
	current_map.add_child( spawner )
	spawner.set_spawn_path( spawn_path )
	spawner.add_to_group( "mob_spawners" )
	
func _spawn_player(infinite_mana: bool, no_damage: bool) -> void:
	var spawn_marker = get_tree().get_first_node_in_group("player_spawn")
	
	if spawn_marker == null:
		push_error( "No player_spawn marker found in map" )
		return
		
	var character_id = GameManager.run_state[ "selected_character" ]
	var player_scene = load( GameManager.CHARACTER_SCENES[character_id] )
	var player = player_scene.instantiate()
	player.global_position = spawn_marker.global_position
		
	current_map.add_child( player )
	
	if infinite_mana:
		player.mana_regen = player.max_mana
	if no_damage:
		player.armor = 100
	
	# Got to do this here so that we have the player camera
	var camera : Camera2D = player.get_node("Camera2D")
	camera.set_limit(SIDE_TOP, current_map.MAX_Y)
	camera.set_limit(SIDE_BOTTOM, current_map.MIN_Y)
	camera.set_limit(SIDE_RIGHT, current_map.MAX_X)
	camera.set_limit(SIDE_LEFT, current_map.MIN_X)
	camera.set_limit_enabled(true)
	camera.set_position_smoothing_enabled(true)
	
	player.died.connect(_on_player_died)
	
func _on_player_died( position : Vector2 ) -> void:
	GameManager.die_on_mission()
	
func _process(delta: float) -> void:
	if current_state == MissionState.NORMAL or current_state == MissionState.OVERTIME:
		mission_timer += delta
		if current_difficulty != MissionRank.NONE:
			_check_overtime()

func _check_overtime() -> void:
	var time_limit = DIFFICULTY_SETTINGS[ current_difficulty ]["timer"]
	if mission_timer >= time_limit and not is_overtime:
		is_overtime = true
		current_state = MissionState.OVERTIME
		print("OVERTIME")

func die() -> void:
	GameManager.die_on_mission()

func complete() -> void:
	current_state = MissionState.COMPLETE
	GameManager.complete_mission()
