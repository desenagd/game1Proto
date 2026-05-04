extends Node

const SCENES: Dictionary = {
	"main_menu": "res://scenes/core/MainMenu/main_menu.tscn",
	"character_select": "res://scenes/core/CharacterSelect/character_select.tscn",
	"stage_01": "res://scenes/core/stage1/stage1.tscn",
	"death_screen": "res://scenes/core/DeathScreen/death_screen.tscn",
}

const CHARACTER_SCENES: Dictionary = {
	"Bucky": "res://scenes/player/characters/bucky/Bucky.tscn",
}

var run_state : Dictionary = {}

func _ready() -> void:
	_reset_run_state()
	
func _reset_run_state() -> void:
	run_state = {
		"selected_character": "",
		"time_alive": 0.0,
		"kills": 0,
		"damage_dealt": 0.0,
		"damage_taken": 0.0,
		"current_stage": "stage_01",
	}
	
func go_to_main_menu() -> void:
	_reset_run_state()
	get_tree().change_scene_to_file( SCENES["main_menu"] )
	
func go_to_character_select() -> void:
	get_tree().change_scene_to_file( SCENES["character_select"] )
	
func start_run( character_id : String ) -> void:
	#var character_id: String = run_state.get("selected_character", "")
	_reset_run_state()
	run_state["selected_character"] = character_id
	get_tree().change_scene_to_file( SCENES["stage_01"] )
	
func restart_run() -> void:
	var character_id: String = run_state.get("selected_character", "")
	var current_stage: String = run_state.get("current_stage", "stage_01")
	_reset_run_state()
	run_state["selected_character"] = character_id
	run_state["current_stage"] = current_stage
	get_tree().change_scene_to_file(SCENES[current_stage])
	
func go_to_death_screen() -> void:
	get_tree().change_scene_to_file( SCENES["death_screen"] )
	
	
