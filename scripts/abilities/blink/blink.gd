extends Ability

class_name Blink

var range : float = 600.0

func _execute( mouse_pos : Vector2 ) -> void:
	var dest := _get_destination( mouse_pos )
	_teleport( dest )

func _get_destination( mouse_pos : Vector2 ) -> Vector2:
	var dist := caster.global_position.distance_to( mouse_pos )
	
	if dist > range:
		var direction := ( mouse_pos - caster.global_position ).normalized()
		return caster.global_position + direction * range
	return mouse_pos
	
func _teleport( dest : Vector2 ) -> void:
	caster.global_position = dest
		
