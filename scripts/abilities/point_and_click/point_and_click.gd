extends Ability
class_name PointAndClick

var damage : int = 3
var reach : float = 100.0

func _execute(mouse_pos : Vector2) -> void:
	#var direction = (mouse_pos - caster.global_position).normalized()
	
	var space = caster.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collision_mask = 3
	query.exclude = [caster.get_rid()]
	
	var results = space.intersect_point( query )
	
	var best = null
	var best_dist = reach
	
	for result in results:
		var dist = mouse_pos.distance_to( result.collider.global_position )
		if dist <= best_dist:
			best_dist = dist
			best = result.collider
	if best and best.has_method("apply_damage"):
		best.apply_damage( damage )
		_on_hit( best )


func _on_hit( target ):
	pass
		
