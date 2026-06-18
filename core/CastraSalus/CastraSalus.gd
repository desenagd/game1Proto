extends Node

func _on_parytron_forge_pressed() -> void:
	GameManager.go_to_parytron_forge()
	
func _on_main_menu_pressed() -> void:
	GameManager.go_to_main_menu()

func _on_go_on_mission_pressed() -> void:
	GameManager.go_on_mission(Mission.RANDOM, Mission.RANDOM)
