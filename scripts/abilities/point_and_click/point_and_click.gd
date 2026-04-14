extends Ability
class_name PointAndClick

var damage : int = 3
var reach : float = 100.0

func _execute(mouse_pos : Vector2) -> void:
	var direction = (mouse_pos - caster.global_position).normalized()
	var space = caster.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		caster.global_position,
		caster.global_position + direction * reach
	)
	
	var result = space.intersect_ray(query)
	if result and result.collider.has_method("apply_damage"):
		result.collider.apply_damage(damage)
		_on_hit( result.collider )
		
func _on_hit( target ):
	pass
		
