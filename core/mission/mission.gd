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
	
const MAPS: Array[ String ] = [
	"res://core/MAPS/Map0/Map0.tscn",
	#add map scenes here
]

const DIFFICULTY_SETTINGS: Dictionary = {
	"EF1" : { "timer" : 120.0},
	"EF2" : { "timer" : 180.0},
	"EF3" : { "timer" : 240.0},
	"EF4" : { "timer" : 300.0},
	"EF5" : { "timer" : 360.0},
}

var current_state : MissionState = MissionState.LOADING
var current_difficulty : String = ""
var current_map : Node = null
var mission_timer : float = 0.0
var is_overtime : bool = false

func _ready() -> void:
	_randomize_mission()
	_load_map()
	_setup_spawners()
	_spawn_player()
	current_state = MissionState.NORMAL
	await get_tree().process_frame
	_notify_spawners()
	
func _randomize_mission() -> void:
	var difficulties = DIFFICULTY_SETTINGS.keys()
	current_difficulty = difficulties[ randi() % difficulties.size() ]
	print( "Mission Difficulty: ", current_difficulty)
	
func _notify_spawners() -> void:
	for spawner in get_tree().get_nodes_in_group("mob_spawners"):
		spawner.set_difficulty( current_difficulty )
		
func _load_map() -> void:
	var map_path = MAPS[ randi() % MAPS.size() ]
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
	
func _spawn_player() -> void:
	var spawn_marker = get_tree().get_first_node_in_group("player_spawn")
	
	if spawn_marker == null:
		push_error( "No player_spawn marker found in map" )
		return
		
	var character_id = GameManager.run_state[ "selected_character" ]
	var player_scene = load( GameManager.CHARACTER_SCENES[character_id] )
	var player = player_scene.instantiate()
	player.global_position = spawn_marker.global_position
	current_map.add_child( player )
	
	player.died.connect(_on_player_died)
	
func _on_player_died( position : Vector2 ) -> void:
	GameManager.die_on_mission()
	
func _process(delta: float) -> void:
	if current_state == MissionState.NORMAL or current_state == MissionState.OVERTIME:
		mission_timer += delta
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
		
