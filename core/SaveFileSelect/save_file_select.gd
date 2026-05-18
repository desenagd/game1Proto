extends Control

func _on_slot_1_pressed() -> void:
	GameManager.new_save_slot(0)
	
func _on_slot_2_pressed() -> void:
	GameManager.new_save_slot(1)
	
func _on_slot_3_pressed() -> void:
	GameManager.new_save_slot(2)
	
func _on_back_pressed() -> void:
	GameManager.go_to_main_menu()
