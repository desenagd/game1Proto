extends Node2D

@onready var difficulty_settings: BoxContainer = $PanelContainer/HBoxContainer/DifficultyBox
@onready var character_select: BoxContainer = $PanelContainer/HBoxContainer/CharacterBox
@onready var map_select: BoxContainer = $PanelContainer/HBoxContainer/MapBox
@onready var other_select: BoxContainer = $PanelContainer/HBoxContainer/OtherSettingsBox

var mission_rank: String = ""
var mission_map: String = ""
var mission_character_id: String = ""

var rank_default: String = rank_to_string(Mission.DIFFICULTY_SETTINGS.keys()[0])
var map_default: String = map_to_string(Mission.MAPS.keys()[0])
var character_default = GameManager.CHARACTER_SCENES.keys()[0]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Fill box continers with available options
	# Difficulties
	# Characters
	# Maps
	# Other settings (No damage, etc.)
	var difficulties = Mission.DIFFICULTY_SETTINGS.keys()
	#difficulties.append(Mission.RANDOM)
	for diff: Mission.MissionRank in difficulties:
		instantiate_and_add_button(difficulty_settings, 
									rank_to_string(diff),
									_on_rank_pressed)
	# Add random option
	instantiate_and_add_button(difficulty_settings, Mission.RANDOM, _on_rank_pressed)
	
	var maps = Mission.MAPS.keys()
	for map in maps:
		instantiate_and_add_button(map_select,
								map_to_string(map),
								_on_map_pressed)
	instantiate_and_add_button(map_select, Mission.RANDOM, _on_rank_pressed)
	
	var characters = GameManager.CHARACTER_SCENES.keys()
	for char in characters:
		instantiate_and_add_button(character_select, char, _on_char_pressed)
	instantiate_and_add_button(character_select, Mission.RANDOM, _on_char_pressed)

# TODO: Gotta update as ranks and maps grow
# Consider doing away with enums, might be more trouble than its worth
func rank_to_string(rank: Mission.MissionRank) -> String:
	match rank:
		Mission.MissionRank.EF1:
			return "EF1"
		Mission.MissionRank.EF2:
			return "EF2"
		Mission.MissionRank.EF3:
			return "EF3"
		Mission.MissionRank.EF4:
			return "EF4"
		Mission.MissionRank.EF5:
			return "EF5"
	return ""

func string_to_rank(str: String) -> Mission.MissionRank:
	match str:
		"EF1":
			return Mission.MissionRank.EF1
		"EF2":
			return Mission.MissionRank.EF2
		"EF3":
			return Mission.MissionRank.EF3
		"EF4":
			return Mission.MissionRank.EF4
		"EF5":
			return Mission.MissionRank.EF5
	return Mission.MissionRank.NONE

func map_to_string(map: Mission.MissionMaps) -> String:
	match map:
		Mission.MissionMaps.TEST:
			return "test"
	return ""

func string_to_map_enum(str: String) -> Mission.MissionMaps:
	match str:
		"test":
			return Mission.MissionMaps.TEST
	return Mission.MissionMaps.NONE

func set_rank(rank: String) -> void:
	mission_rank = rank

func set_map(map: String) -> void:
	mission_map = map

func set_character(character_name: String) -> void:
	mission_character_id = character_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func choose_random_char_id() -> String:
	return GameManager.CHARACTER_SCENES.keys()[randi() % GameManager.CHARACTER_SCENES.size()]

func instantiate_and_add_button(container: BoxContainer, 
								text: String, 
								connect_function) -> void:
	var butt: Button = Button.new()
	butt.text = text
	butt.toggle_mode = true
	butt.pressed.connect(connect_function.bind(butt, container))
	container.add_child(butt)
	
	# Maybe put this somewhere else later, convenient for now
	# Set default button settings
	if text == map_default or text == rank_default || text == character_default:
		butt.emit_signal("pressed")

func clear_column_pressed(container: BoxContainer) -> void:
	for child in container.get_children():
		if child is Button:
			child.button_pressed = false
	#var button_children = container.find_children("*", "Button")
	#for butt: Button in button_children:
		#butt.button_pressed = false

func _on_rank_pressed(butt: Button, parent: BoxContainer):
	set_rank(butt.text)
	clear_column_pressed(parent)
	butt.button_pressed = true

func _on_map_pressed(butt: Button, parent: BoxContainer):
	set_map(butt.text)
	clear_column_pressed(parent)
	butt.button_pressed = true

func _on_char_pressed(butt: Button, parent: BoxContainer):
	set_character(butt.text)
	clear_column_pressed(parent)
	butt.button_pressed = true

func _on_back_pressed():
	GameManager.back_to_main_menu()

func _on_start_button_pressed():
	# Can change later if this looks ugly
	# Just to cover "random" edge case
	GameManager.set_character(mission_character_id if mission_character_id != Mission.RANDOM else choose_random_char_id())
	GameManager.go_on_mission(mission_rank if mission_rank == Mission.RANDOM else string_to_rank(mission_rank), 
							mission_map if mission_map == Mission.RANDOM else string_to_map_enum(mission_map))
