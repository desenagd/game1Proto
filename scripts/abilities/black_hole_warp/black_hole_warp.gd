extends Blink

class_name BlackHoleWarp

const EXIT_EFFECT = preload("res://scenes/abilities/black_hole_warp/warp_exit_effect.tscn")
const ENTER_EFFECT = preload("res://scenes/abilities/black_hole_warp/warp_enter_effect.tscn")

func _ready() -> void:
	mana_cost = 5
	cooldown = 1.0
	range = 600.0
	
func _execute( mouse_pos : Vector2 ) -> void:
	#print("EXECUTE CALLED - setting enchained")
	#print("caster instance id: ", caster.get_instance_id())
	caster.is_enchained = true
	#print("is_enchained is now: ", caster.is_enchained)
	var dest := _get_destination( mouse_pos )
	await _teleport( dest )
	
func _teleport( dest : Vector2 ) -> void:
	caster.is_enchained = true
	#print("caster.is_enchained state: " + str( caster.is_enchained) )
	
	var exit = EXIT_EFFECT.instantiate()
	caster.get_tree().current_scene.add_child( exit )
	exit.global_position = caster.global_position
	
	caster.visible = false
	
	await exit.animation_finished
	
	caster.global_position = dest
	
	
	var enter = ENTER_EFFECT.instantiate()
	caster.get_tree().current_scene.add_child( enter )
	enter.global_position = dest
	await enter.animation_finished
	caster.visible = true
	
	caster.is_enchained = false
	
