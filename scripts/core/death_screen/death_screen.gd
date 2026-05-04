extends Control

@onready var title_label: Label = $CenterContainer/VBoxContainer/TitleLabel
@onready var time_label: Label = $CenterContainer/VBoxContainer/PanelContainer/StatsVBox/TimeLabel
@onready var kills_label: Label = $CenterContainer/VBoxContainer/PanelContainer/StatsVBox/KillsLabel
@onready var dmg_dealt_label: Label = $CenterContainer/VBoxContainer/PanelContainer/StatsVBox/DmgDealtLabel
@onready var dmg_taken_label: Label = $CenterContainer/VBoxContainer/PanelContainer/StatsVBox/DmgTakenLabel
@onready var runtime_label: Label = $CenterContainer/VBoxContainer/PanelContainer/StatsVBox/RunTimeLabel
@onready var retry_button: Button = $CenterContainer/VBoxContainer/RetryButton
@onready var char_select_button: Button = $CenterContainer/VBoxContainer/CharSelectButton
@onready var main_menu_button: Button = $CenterContainer/VBoxContainer/MainMenuButton

func _ready() -> void:
	title_label.text = "YOU DIED"
	retry_button.pressed.connect( _on_retry_pressed )
	char_select_button.pressed.connect( _on_char_select_pressed )
	main_menu_button.pressed.connect( _on_main_menu_pressed )
	_populate_stats()
	
func _populate_stats() -> void:
	time_label.text = "Time: %s" % _format_time(0.0)
	kills_label.text = "Kills: 0"
	dmg_dealt_label.text = "Damage Dealt: 0"
	dmg_taken_label.text = "Damage Taken: 0"
	runtime_label.text = "Run Time: %s" % _format_time(0.0)
	
func _format_time( seconds : float ) -> String:
	var m : int = int( seconds ) / 60
	var s : int = int( seconds ) % 60
	return "%02d:%02d" % [m, s]
	
func _on_retry_pressed() -> void:
	SceneManager.restart_run()

func _on_char_select_pressed() -> void:
	SceneManager.go_to_character_select()

func _on_main_menu_pressed() -> void:
	SceneManager.go_to_main_menu()
	
