extends Control

@onready var new_run_button : Button = $CenterContainer/VBoxContainer/NewRunButton
@onready var options_button: Button = $CenterContainer/VBoxContainer/OptionsButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/ExitButton

func _ready() -> void:
	new_run_button.pressed.connect( _on_new_run_pressed )
	options_button.pressed.connect( _on_options_pressed )
	exit_button.pressed.connect( _on_exit_pressed )
	
func _on_new_run_pressed() -> void:
	SceneManager.go_to_character_select()
	
func _on_options_pressed() -> void:
	pass
	
func _on_exit_pressed() -> void:
	get_tree().quit()
