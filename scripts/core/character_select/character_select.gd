extends Control

const ROSTER: Array[ Dictionary ] = [
	{
		"name": "Bucky",
		"description": "This mysterious character might not even be real... maybe he's... imaginary....",
		"passive": "Haven't made this yet lowkey LOL but I will soon",
		"abilities": ["Light Punch - Lightining fast punches that mysteriously appear on the target", 
					  "Rocket Punch - A Projectile Rocket Fist that is a skillshot",
					  "Tumble - A super fast dash in a direction"],
		"scene": "res://scenes/player/characters/bucky/Bucky.tscn"
	},
]

@onready var character_grid : GridContainer = $ScrollContainer/CharacterGrid
@onready var name_label : Label = $PreviewPanel/VBoxContainer/NameLabel
@onready var desc_label: Label = $PreviewPanel/VBoxContainer/DescLabel
@onready var passive_label: Label = $PreviewPanel/VBoxContainer/PassiveLabel
@onready var ability1: Label = $PreviewPanel/VBoxContainer/AbilityContainer/Ability1
@onready var ability2: Label = $PreviewPanel/VBoxContainer/AbilityContainer/Ability2
@onready var ability3: Label = $PreviewPanel/VBoxContainer/AbilityContainer/Ability3
@onready var select_button: Button = $PreviewPanel/VBoxContainer/SelectButton

var _selected_index : int = 0

func _ready() -> void:
	select_button.pressed.connect( _on_select_pressed )
	_build_grid()
	_preview(0)
	
func _build_grid() -> void:
	for i in ROSTER.size():
		var btn := Button.new()
		btn.text = ROSTER[i]["name"]
		btn.pressed.connect( _preview.bind(i) )
		character_grid.add_child( btn )

func _preview( index: int ) -> void:
	_selected_index = index
	var data: Dictionary = ROSTER[index]
	name_label.text = data["name"]
	desc_label.text = data["description"]
	passive_label.text = data["passive"]
	ability1.text = data["abilities"][0]
	ability2.text = data["abilities"][1]
	ability3.text = data["abilities"][2]
	select_button.text = "Play as %s" % data["name"]
	
func _on_select_pressed() -> void:
	SceneManager.start_run( ROSTER[_selected_index]["name"])
	
	
	
	
	
	
	
	
	
	
	
	
