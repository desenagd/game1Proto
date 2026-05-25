extends Node

const SCENES: Dictionary = {
	"main_menu": "res://core/MainMenu/main_menu.tscn",
	"save_file_select" : "res://core/SaveFileSelect/SaveFileSelect.tscn",
	"castra_salus" : "res://core/CastraSalus/CastraSalus.tscn",
	"parytron_forge" : "res://core/ParytronForge/ParytronForge.tscn",
	"mission" : "res://core/mission/mission.tscn",
	"character_select": "res://core/CharacterSelect/character_select.tscn",
	"options" : "res://core/options/options.tscn",
	"records" : "res://core/Records/records.tscn",
	"death_screen": "res://core/DeathScreen/death_screen.tscn",
	
	#"stage_01": "res://core/stage1/stage1.tscn",
}

const CHARACTER_SCENES: Dictionary = {
	"Bucky": "res://scenes/player/characters/bucky/Bucky.tscn",
	"Yuri Shephard" : "res://scenes/player/characters/yuri_shephard/yuri_shephard.tscn"
}

#------ SAVE SLOTS 1, 2, 3 are populated when player picks a file-------#
var current_save_slot : int = -1

#----- RUN STATE (reset at the start of a new run) --------#
var run_state : Dictionary = {}

#-------- RECORDS ( persists across run and written to on run death ) ---------#
var records : Array[ Dictionary ]

# ------- READY ----------#
func _ready() -> void:
	_wipe_run_state()
	
#-----------------------------------#
#------ HELPER FUNCTIONS -----------#
#-----------------------------------#

func _wipe_run_state() -> void:
	run_state = {
		"selected_character" : "",
		"time_alive" : 0.0,
		"kills" : 0,
		"boss_kills" : 0,
		"damage_dealt" : 0.0,
		"damage_taken" : 0.0,
		"missions_completed" : 0,
		# add more things like final stats and items/artifacts
	}
	
func _save_run_to_records() -> void:
	records.append( run_state.duplicate()  )
	
	
#---------------------------------------------------#
#----------------- NAVIGATION ----------------------#
#---------------------------------------------------#
	
func go_to_main_menu() -> void:
	# TODO - save run_state to disk here (current_save_slot))
	get_tree().change_scene_to_file( SCENES["main_menu"] )
	
func go_to_save_file_select() -> void:
	get_tree().change_scene_to_file( SCENES[ "save_file_select" ] )
	
func new_save_slot( slot : int ) -> void:
	current_save_slot = slot
	get_tree().change_scene_to_file( SCENES["character_select"] )
	
func load_save_slot( slot : int ) -> void:
	current_save_slot = slot
	#TODO - DESERIALIZE SAVE DATA FROM DISK INTO RUN_STATE HERE
	get_tree().change_scene_to_file( SCENES["castra_salus"] )
	
func confirm_character( character_id : String ) -> void:
	run_state["selected_character"] = character_id
	#TODO - INITIALIZE AND WRITE NEW SAVE FILE TO DISK HERE
	get_tree().change_scene_to_file( SCENES["castra_salus"] )
	
func go_on_mission() -> void:
	# TODO: mission selection logic goes here (random pick, difficulty, etc.)
	get_tree().change_scene_to_file( SCENES["mission"] )
	
func back_to_castra_salus() -> void:
	# TODO: This will may need to be changed to factor in save slot data
	get_tree().change_scene_to_file( SCENES["castra_salus"] )
	
func complete_mission() -> void:
	#TODO - APPLY MISSION REWARDS TO SAVE DATA HERE
	get_tree().change_scene_to_file( SCENES["castra_salus"] )
	
func die_on_mission() -> void:
	_save_run_to_records()
	_wipe_run_state()
	get_tree().change_scene_to_file( SCENES["death_screen"] )
	
func death_to_main_menu() -> void:
	get_tree().change_scene_to_file( SCENES["main_menu"] )
	
func go_to_parytron_forge() -> void:
	get_tree().change_scene_to_file( SCENES["parytron_forge"] )
	
func go_to_options() -> void:
	get_tree().change_scene_to_file( SCENES["options"] )
	
func go_to_records() -> void:
	get_tree().change_scene_to_file( SCENES["records"] )
	
func back_to_main_menu() -> void:
	get_tree().change_scene_to_file( SCENES["main_menu"])

func quit_game() -> void:
	get_tree().quit()
