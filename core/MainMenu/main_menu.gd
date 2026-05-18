extends Control

func _on_play_pressed() -> void:
	GameManager.go_to_save_file_select()
	
func _on_options_pressed() -> void:
	GameManager.go_to_options()
	
func _on_records_pressed() -> void:
	GameManager.go_to_records()
	
func _on_exit_pressed() -> void:
	GameManager.quit_game()
