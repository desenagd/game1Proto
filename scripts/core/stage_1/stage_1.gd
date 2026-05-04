extends Node2D

@onready var player_spawn : Marker2D = $player_spawn
@onready var entity_layer : Node2D = $EntityLayer

var _player : Node = null

func _ready() -> void:
	SceneManager.run_state["current_stage"] = "stage_01"
	_spawn_player()
	
func _spawn_player() -> void:
	var character_id : String = SceneManager.run_state.get( "selected_character", "")
	if character_id == "":
		push_error("Stage1: no character selected!")
		return
	
	var scene_path : String = SceneManager.CHARACTER_SCENES.get( character_id, "" )
	if scene_path == "":
		push_error( "Stage1: no scene found for character '%s'" % character_id )
		return
		
	var packed: PackedScene = load( scene_path )
	var _player = packed.instantiate()
	_player.position = player_spawn.position
	entity_layer.add_child( _player )
	
	_player.died.connect( _on_player_died )
	
func _on_player_died( _death_position : Vector2 ) -> void:
	await _wait_for_player_freed()
	SceneManager.go_to_death_screen()
	
func _wait_for_player_freed() -> void:
	while is_instance_valid( _player ):
		await get_tree().process_frame
	await get_tree().process_frame
	
