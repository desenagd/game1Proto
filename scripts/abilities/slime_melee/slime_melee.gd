extends Ability
class_name SlimeMelee

var damage : int = 10
var reach : float = 60.0

func _execute(mouse_pos : Vector2) -> void:
	var direction = (mouse_pos - caster.global_position).normalized()
	var space = caster.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		caster.global_position,
		caster.global_position + direction * reach
	)
	query.exclude = [caster]
	var result = space.intersect_ray(query)
	if result and result.collider.has_method("apply_damage"):
		result.collider.apply_damage(damage)
		print(caster.name, " hit ", result.collider.name, " for ", damage)
